import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import 'brand.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.bottom,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.page,
      AppSpacing.xs,
      AppSpacing.page,
      AppSpacing.xl,
    ),
    this.scrollable = true,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? bottom;
  final EdgeInsets padding;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final content = scrollable
        ? ListView(padding: padding, children: [body])
        : Padding(padding: padding, child: body);

    return Scaffold(
      appBar: title == null
          ? null
          : AppBar(title: Text(title!), actions: actions),
      body: SafeArea(
        top: title != null,
        child: AppPage(child: content),
      ),
      bottomNavigationBar: bottom,
    );
  }
}
