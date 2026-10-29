import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/brand_logo.dart';
import '../../../shared/providers/providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  var _obscure = true;
  var _submitted = false;
  var _emailMode = false;

  @override
  void dispose() {
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authControllerProvider.notifier)
        .login(
          phone: _emailMode ? null : _phone.text,
          email: _emailMode ? _email.text : null,
          password: _password.text,
        );
  }

  void _toggleMode() {
    setState(() {
      _emailMode = !_emailMode;
      _submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                autovalidateMode: _submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: BrandLogo(variant: BrandMark.lockup, size: 320),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Welcome Back',
                      style: text.headlineMedium?.copyWith(
                        color: AppColors.forest,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Invest in halal businesses. Build a better future.',
                      style: text.bodyMedium?.copyWith(color: AppColors.muted),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (auth.error != null) ...[
                      _ErrorBanner(message: auth.error!),
                      const SizedBox(height: 12),
                    ],
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _emailMode
                          ? AppTextField(
                              key: WidgetKeys.loginEmail,
                              controller: _email,
                              label: 'Email address',
                              hint: 'name@email.com',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              validator: Validators.email,
                              textInputAction: TextInputAction.next,
                            )
                          : AppTextField(
                              key: WidgetKeys.loginPhone,
                              controller: _phone,
                              label: 'Phone number',
                              hint: '+254712345678',
                              prefixIcon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              autofillHints: const [
                                AutofillHints.telephoneNumber,
                              ],
                              validator: Validators.phone,
                              textInputAction: TextInputAction.next,
                            ),
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      key: WidgetKeys.loginPassword,
                      controller: _password,
                      label: 'Password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscure,
                      autofillHints: const [AutofillHints.password],
                      validator: Validators.password,
                      suffix: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        tooltip: _obscure ? 'Show password' : 'Hide password',
                      ),
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push(AppRoutes.forgotPassword),
                        child: const Text('Forgot password'),
                      ),
                    ),
                    AppButton(
                      key: WidgetKeys.loginSubmit,
                      label: 'Login',
                      busy: auth.busy,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: auth.busy ? null : _toggleMode,
                      icon: Icon(
                        _emailMode
                            ? Icons.phone_outlined
                            : Icons.email_outlined,
                      ),
                      label: Text(
                        _emailMode
                            ? 'Continue with Phone'
                            : 'Continue with Email',
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_emailMode)
                      Text(
                        'Demonstration sign-in. No verification email is sent.',
                        style: text.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    AppButton(
                      key: WidgetKeys.demoLogin,
                      label: 'Explore the demo portfolio',
                      variant: AppButtonVariant.text,
                      onPressed: auth.busy
                          ? null
                          : () => ref
                                .read(authControllerProvider.notifier)
                                .enterDemo(),
                    ),
                    Text(
                      'Demonstration account ${AppConstants.demoPhone} or ${AppConstants.demoEmail} · ${AppConstants.demoPassword}',
                      style: text.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text("Don't have an account?", style: text.bodyMedium),
                        TextButton(
                          onPressed: () => context.push(AppRoutes.register),
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.dangerSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: AppColors.danger),
      ),
    );
  }
}
