import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/state_views.dart';
import '../../../shared/providers/providers.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final _manual = TextEditingController();
  var _looking = false;
  var _handled = false;

  @override
  void dispose() {
    _manual.dispose();
    super.dispose();
  }

  bool get _cameraSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  Future<void> _lookup(String raw) async {
    final certificateId = _normalize(raw);
    if (certificateId.isEmpty || _looking) return;
    setState(() => _looking = true);
    final holding = await ref
        .read(investmentRepositoryProvider)
        .holdingForCertificate(certificateId);
    if (!mounted) return;
    setState(() => _looking = false);
    if (holding == null) {
      showAppMessage(
        context,
        'No demonstration certificate matches $certificateId.',
      );
      _handled = false;
      return;
    }
    context.push(AppRoutes.certificate(holding.certificateId));
  }

  String _normalize(String raw) {
    final value = raw.trim();
    final match = RegExp(r'BARAKAH-SHARE-\d+').firstMatch(value.toUpperCase());
    return match?.group(0) ?? value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan certificate')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const DemoNotice(
            message: 'Look up a demonstration certificate such as BARAKAH-SHARE-0088. The camera scanner runs on a phone.',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _manual,
            decoration: const InputDecoration(labelText: 'Certificate number'),
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Look up certificate',
            busy: _looking,
            onPressed: () => _lookup(_manual.text),
          ),
          const SizedBox(height: 16),
          if (_cameraSupported)
            SizedBox(
              height: 280,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MobileScanner(
                  onDetect: (capture) {
                    final raw = capture.barcodes.isEmpty
                        ? null
                        : capture.barcodes.first.rawValue;
                    if (raw == null || _handled) return;
                    _handled = true;
                    _lookup(raw);
                  },
                ),
              ),
            )
          else
            const EmptyView(
              title: 'Camera scanning is on the phone app',
              message: 'Use the certificate number field on this device.',
            ),
        ],
      ),
    );
  }
}
