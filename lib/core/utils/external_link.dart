import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_colors.dart';

/// Opens a real external URL. Callers must only pass live references.
Future<void> openExternalLink(BuildContext context, Uri uri) async {
  var opened = false;
  try {
    opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on Object {
    opened = false;
  }
  if (opened || !context.mounted) return;
  await Clipboard.setData(ClipboardData(text: uri.toString()));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('The link could not be opened. It was copied instead.'),
      backgroundColor: AppColors.navy,
    ),
  );
}
