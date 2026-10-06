import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.busy = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: ElevatedButton(
        onPressed: busy ? null : onPressed,
        child: busy
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : _label(context),
      ),
    );
  }

  Widget _label(BuildContext context) {
    final style = Theme.of(context).elevatedButtonTheme.style?.textStyle
        ?.resolve({});
    final child = Text(label, style: style);
    if (icon == null) return child;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: AppSpacing.xs),
        child,
      ],
    );
  }
}

class PrimaryButton extends AppButton {
  const PrimaryButton({
    super.key,
    required super.label,
    required super.onPressed,
    super.icon,
    super.busy,
  });
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: OutlinedButton(
        onPressed: onPressed,
        child: icon == null
            ? Text(label)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 18),
                  const SizedBox(width: AppSpacing.xs),
                  Text(label),
                ],
              ),
      ),
    );
  }
}
