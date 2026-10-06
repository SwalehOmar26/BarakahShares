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
import '../../core/widgets/brand.dart';
import '../../models/enums.dart';
import '../../providers/providers.dart';
import 'widgets/auth_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phone = TextEditingController();
  final _password = TextEditingController();
  UserRole _role = UserRole.youthInvestor;
  bool _obscure = true;
  String? _localError;

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _localError = null);
    final ok = await ref
        .read(authControllerProvider.notifier)
        .login(phone: _phone.text, password: _password.text, role: _role);
    if (!mounted || !ok) return;
    final user = ref.read(authControllerProvider).user;
    final next = user?.kycStatus == KycStatus.verified
        ? AppRoutes.home
        : AppRoutes.kyc;
    context.go(next);
  }

  Future<void> _forgot() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset password'),
        content: const Text(
          'This demonstration does not send an SMS. Use Demo1234 with +254700000000, or create a new account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final error = _localError ?? auth.error;
    return AppScaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          const BrandMark(size: 56),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Welcome to BarakahShares',
            style: brandStyle(
              size: 32,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Invest in halal businesses. Own a share. Share the success.',
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpacing.xl),
          RoleSelector(
            value: _role,
            onChanged: (role) => setState(() => _role = role),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            key: const Key('phone-field'),
            controller: _phone,
            label: 'Phone number',
            hint: '700 000 000',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            prefix: const Icon(Icons.phone_outlined),
            autofillHints: const [AutofillHints.telephoneNumber],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            key: const Key('password-field'),
            controller: _password,
            label: 'Password',
            obscure: _obscure,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
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
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _forgot,
              child: const Text('Forgot Password'),
            ),
          ),
          if (error != null) ...[
            Text(error, style: const TextStyle(color: AppColors.error)),
            const SizedBox(height: AppSpacing.sm),
          ],
          PrimaryButton(
            key: const Key('login-button'),
            label: 'Login',
            busy: auth.isLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(
            label: 'Create Account',
            onPressed: () => context.go(AppRoutes.register),
          ),
          const SizedBox(height: AppSpacing.xl),
          const TrustRow(),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
