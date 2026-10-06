import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_spacing.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.obscure = false,
    this.prefix,
    this.suffix,
    this.errorText,
    this.textInputAction,
    this.onSubmitted,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscure;
  final Widget? prefix;
  final Widget? suffix;
  final String? errorText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: label,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        autofillHints: autofillHints,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: prefix,
          suffixIcon: suffix,
          errorText: errorText,
        ),
      ),
    );
  }
}

class AmountInput extends StatefulWidget {
  const AmountInput({
    super.key,
    required this.amount,
    required this.step,
    required this.onChanged,
    this.min = 0,
    this.max,
  });

  final int amount;
  final int step;
  final ValueChanged<int> onChanged;
  final int min;
  final int? max;

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.amount.toString());
  }

  @override
  void didUpdateWidget(AmountInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount != widget.amount &&
        _controller.text != widget.amount.toString()) {
      _controller.text = widget.amount.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _step(
          Icons.remove,
          () => widget.onChanged(_clamp(widget.amount - widget.step)),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
            decoration: const InputDecoration(
              prefixText: 'KES ',
              labelText: 'Investment amount',
            ),
            onSubmitted: (value) {
              final parsed = int.tryParse(value) ?? widget.min;
              widget.onChanged(_clamp(parsed));
            },
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _step(
          Icons.add,
          () => widget.onChanged(_clamp(widget.amount + widget.step)),
        ),
      ],
    );
  }

  int _clamp(int value) {
    var next = value;
    if (next < widget.min) next = widget.min;
    if (widget.max != null && next > widget.max!) next = widget.max!;
    if (widget.step > 0) next = (next ~/ widget.step) * widget.step;
    if (next < widget.min) next = widget.min;
    return next;
  }

  Widget _step(IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: 48,
      height: 48,
      child: IconButton.outlined(onPressed: onTap, icon: Icon(icon)),
    );
  }
}
