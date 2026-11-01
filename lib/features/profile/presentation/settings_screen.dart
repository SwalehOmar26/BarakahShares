import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../shared/providers/providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  var _notices = true;
  var _busy = false;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final error = Validators.password(_next.text);
    if (error != null) {
      showAppMessage(context, error);
      return;
    }
    setState(() => _busy = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .changePassword(
            currentPassword: _current.text,
            nextPassword: _next.text,
          );
      if (!mounted) return;
      _current.clear();
      _next.clear();
      showAppMessage(context, 'Password updated in this demonstration store.');
    } on AuthException catch (error) {
      if (!mounted) return;
      showAppMessage(context, error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).user;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Signed in as ${user?.phone ?? '—'}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Demonstration notices'),
            subtitle: const Text(
              'Stored only in this session. No push service is connected.',
            ),
            value: _notices,
            onChanged: (value) => setState(() => _notices = value),
          ),
          const SizedBox(height: 8),
          Text(
            'Change password',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          AppTextField(
            controller: _current,
            label: 'Current password',
            obscureText: true,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _next,
            label: 'New password',
            obscureText: true,
            validator: Validators.password,
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Update password',
            busy: _busy,
            onPressed: _changePassword,
          ),
          const SizedBox(height: 20),
          Text(
            'API base URL is read from the build configuration and is not stored in the app.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
