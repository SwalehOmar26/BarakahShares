import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/routing/routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_text_field.dart';
import '../../providers/providers.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final _code = TextEditingController();
  String? _message;
  var _handled = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _lookup(String raw) async {
    if (_handled) return;
    final code = _extract(raw);
    final certificate = await ref
        .read(certificateRepositoryProvider)
        .fetchByCode(code);
    if (!mounted) return;
    if (certificate == null) {
      setState(() => _message = 'No certificate matches $code.');
      return;
    }
    _handled = true;
    context.push(AppRoutes.holding(certificate.investmentId));
  }

  String _extract(String raw) {
    final uri = Uri.tryParse(raw.trim());
    if (uri != null && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.last;
    }
    return raw.trim();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Scan certificate',
      scrollable: false,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Point the camera at a certificate QR, or enter the code.',
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: MobileScanner(
                onDetect: (capture) {
                  if (capture.barcodes.isEmpty) return;
                  final raw = capture.barcodes.first.rawValue;
                  if (raw == null || raw.isEmpty) return;
                  _lookup(raw);
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            controller: _code,
            label: 'Certificate code',
            hint: 'BARAKAH-SHARE-0088',
          ),
          if (_message != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(_message!),
          ],
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(
            label: 'Look up code',
            onPressed: () => _lookup(_code.text),
          ),
        ],
      ),
    );
  }
}
