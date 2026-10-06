import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_text_field.dart';
import '../../models/enums.dart';
import '../../providers/providers.dart';
import 'widgets/auth_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  UserRole _role = UserRole.youthInvestor;
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await ref
        .read(authControllerProvider.notifier)
        .register(
          name: _name.text,
          phone: _phone.text,
          password: _password.text,
          role: _role,
        );
    if (!mounted || !ok) return;
    context.go(AppRoutes.kyc);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    return AppScaffold(
      title: 'Create Account',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Open a BarakahShares account', style: brandStyle(size: 28)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Identity verification is required before you can invest.',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpacing.lg),
          RoleSelector(
            value: _role,
            onChanged: (role) => setState(() => _role = role),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _name,
            label: 'Full name',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            controller: _phone,
            label: 'Phone number',
            hint: '700 000 000',
            keyboardType: TextInputType.phone,
            prefix: const Icon(Icons.phone_outlined),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            controller: _password,
            label: 'Password',
            obscure: _obscure,
            prefix: const Icon(Icons.lock_outline),
            suffix: IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(
                _obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
          if (auth.error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(auth.error!, style: const TextStyle(color: AppColors.error)),
          ],
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Create Account',
            busy: auth.isLoading,
            onPressed: _submit,
          ),
          TextButton(
            onPressed: () => context.go(AppRoutes.login),
            child: const Text('I already have an account'),
          ),
        ],
      ),
    );
  }
}
