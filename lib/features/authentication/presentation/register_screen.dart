import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/state_views.dart';
import '../../../shared/models/app_user.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/repositories/auth_repository.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _business = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  var _role = UserRole.investor;
  var _obscurePassword = true;
  var _obscureConfirm = true;
  var _submitted = false;

  @override
  void dispose() {
    _name.dispose();
    _business.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authControllerProvider.notifier)
        .register(
          RegistrationDraft(
            fullName: _name.text,
            phone: _phone.text,
            email: _email.text,
            password: _password.text,
            role: _role,
            businessName: _role == UserRole.businessOwner
                ? _business.text
                : null,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Form(
                key: _formKey,
                autovalidateMode: _submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Join BarakahShares', style: text.headlineSmall),
                    const SizedBox(height: 8),
                    const DemoNotice(
                      message: 'Registration is stored only on this device. It does not verify your email or open a regulated investment account.',
                    ),
                    const SizedBox(height: 16),
                    SegmentedButton<UserRole>(
                      segments: const [
                        ButtonSegment(
                          value: UserRole.investor,
                          label: Text('Investor'),
                          icon: Icon(Icons.person_outline),
                        ),
                        ButtonSegment(
                          value: UserRole.businessOwner,
                          label: Text('Business'),
                          icon: Icon(Icons.storefront_outlined),
                        ),
                      ],
                      selected: {_role},
                      onSelectionChanged: (value) =>
                          setState(() => _role = value.first),
                    ),
                    const SizedBox(height: 16),
                    if (auth.error != null) ...[
                      Text(
                        auth.error!,
                        style: text.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    AppTextField(
                      key: WidgetKeys.registerName,
                      controller: _name,
                      label: _role == UserRole.investor
                          ? 'Full name'
                          : 'Owner full name',
                      prefixIcon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      validator: (value) => Validators.personName(value),
                    ),
                    if (_role == UserRole.businessOwner) ...[
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _business,
                        label: 'Business name',
                        validator: (value) => Validators.personName(
                          value,
                          label: 'business name',
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    AppTextField(
                      key: WidgetKeys.registerPhone,
                      controller: _phone,
                      label: 'Phone number',
                      hint: '+254712345678',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      textInputAction: TextInputAction.next,
                      validator: Validators.phone,
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      key: WidgetKeys.registerEmail,
                      controller: _email,
                      label: 'Email address',
                      hint: 'name@email.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      key: WidgetKeys.registerPassword,
                      controller: _password,
                      label: 'Password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      autofillHints: const [AutofillHints.newPassword],
                      textInputAction: TextInputAction.next,
                      validator: Validators.password,
                      suffix: IconButton(
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        tooltip: _obscurePassword
                            ? 'Show password'
                            : 'Hide password',
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      key: WidgetKeys.registerConfirm,
                      controller: _confirm,
                      label: 'Confirm password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      validator: (value) =>
                          Validators.confirmPassword(value, _password.text),
                      suffix: IconButton(
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        tooltip: _obscureConfirm
                            ? 'Show password'
                            : 'Hide password',
                      ),
                    ),
                    const SizedBox(height: 8),
                    FormField<bool>(
                      initialValue: false,
                      validator: (value) {
                        if (value != true) {
                          return 'Accept the Terms and Conditions to continue.';
                        }
                        return null;
                      },
                      builder: (field) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              key: WidgetKeys.registerTerms,
                              contentPadding: EdgeInsets.zero,
                              value: field.value ?? false,
                              onChanged: (value) =>
                                  field.didChange(value ?? false),
                              title: const Text(
                                'I accept the Terms and Conditions.',
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            if (field.hasError)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  field.errorText!,
                                  style: text.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    AppButton(
                      key: WidgetKeys.registerSubmit,
                      label: 'Create account',
                      busy: auth.busy,
                      onPressed: _submit,
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: text.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go(AppRoutes.login);
                            }
                          },
                          child: const Text('Log in'),
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
