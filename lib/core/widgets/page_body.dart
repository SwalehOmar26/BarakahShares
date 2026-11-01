import 'package:flutter/material.dart';

class PageBody extends StatelessWidget {
  const PageBody({
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 28),
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
