import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/state_views.dart';
import '../../../core/widgets/verification_badge.dart';
import '../../../shared/models/kyc_state.dart';
import '../../../shared/providers/providers.dart';

class KycScreen extends ConsumerStatefulWidget {
  const KycScreen({super.key});

  @override
  ConsumerState<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends ConsumerState<KycScreen> {
  var _step = 0;
  var _idType = 'National ID';
  final _idNumber = TextEditingController();
  var _fileAttached = false;
  String? _error;

  @override
  void dispose() {
    _idNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kyc = ref.watch(kycControllerProvider);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Identity verification')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          const DemoNotice(
            message: 'Smile ID capture will connect here. No document or selfie is uploaded, and this demonstration does not verify your identity.',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StepDot(index: 0, current: _step, label: 'Identity'),
              _StepDot(index: 1, current: _step, label: 'Selfie'),
              _StepDot(index: 2, current: _step, label: 'Status'),
            ],
          ),
          const SizedBox(height: 18),
          if (_step == 0) ...[
            Text('Identity document', style: text.titleLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _idType,
              decoration: const InputDecoration(labelText: 'Document type'),
              items: const [
                DropdownMenuItem(
                  value: 'National ID',
                  child: Text('National ID'),
                ),
                DropdownMenuItem(value: 'Passport', child: Text('Passport')),
                DropdownMenuItem(value: 'Alien ID', child: Text('Alien ID')),
              ],
              onChanged: (value) =>
                  setState(() => _idType = value ?? 'National ID'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _idNumber,
              decoration: const InputDecoration(labelText: 'Document number'),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: _fileAttached
                  ? 'Sample file attached'
                  : 'Attach sample file',
              variant: AppButtonVariant.secondary,
              onPressed: () => setState(() => _fileAttached = true),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: AppColors.danger)),
            ],
            const SizedBox(height: 12),
            AppButton(
              label: 'Continue',
              onPressed: () {
                if (_idNumber.text.trim().length < 6 || !_fileAttached) {
                  setState(
                    () => _error = 'Enter a document number of at least 6 characters and attach the sample file.',
                  );
                  return;
                }
                ref
                    .read(kycControllerProvider.notifier)
                    .saveIdentity(
                      idType: _idType,
                      idNumber: _idNumber.text.trim(),
                    );
                setState(() {
                  _error = null;
                  _step = 1;
                });
              },
            ),
          ],
          if (_step == 1) ...[
            Text('Selfie and liveness', style: text.titleLarge),
            const SizedBox(height: 8),
            Container(
              height: 220,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.forest,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.gold, width: 2),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.face_retouching_natural,
                    color: AppColors.gold,
                    size: 64,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Camera frame',
                    style: TextStyle(color: AppColors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              kyc.sampleSelfieCaptured
                  ? 'Sample selfie stored on this device. Liveness detection did not run.'
                  : 'Capture a sample selfie to continue. This does not verify you.',
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Capture sample selfie',
              variant: AppButtonVariant.secondary,
              onPressed: () =>
                  ref.read(kycControllerProvider.notifier).markSampleSelfie(),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Review status',
              onPressed: kyc.sampleSelfieCaptured
                  ? () => setState(() => _step = 2)
                  : null,
            ),
          ],
          if (_step == 2) ...[
            Text('Verification status', style: text.titleLarge),
            const SizedBox(height: 8),
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoRow(label: 'Document', value: _statusLabel(kyc.identity)),
                  InfoRow(label: 'Selfie', value: _statusLabel(kyc.selfie)),
                  InfoRow(label: 'Current status', value: kyc.overallLabel),
                  const SizedBox(height: 8),
                  Text(kyc.note),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text('Possible statuses', style: text.titleMedium),
            const SizedBox(height: 8),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                VerificationBadge(label: 'Not started'),
                VerificationBadge(label: 'Pending', tone: BadgeTone.pending),
                VerificationBadge(label: 'Verified', tone: BadgeTone.verified),
                VerificationBadge(label: 'Rejected', tone: BadgeTone.rejected),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Verified and rejected are shown so the labels are clear. This demonstration does not assign them.',
            ),
            const SizedBox(height: 12),
            AppButton(
              label: kyc.overall == KycStepStatus.pending
                  ? 'Submitted — pending review'
                  : 'Submit for review',
              onPressed: kyc.overall == KycStepStatus.pending
                  ? null
                  : () {
                      ref.read(kycControllerProvider.notifier).submit();
                      showAppMessage(
                        context,
                        'Submitted as pending. Identity is not verified.',
                      );
                    },
            ),
          ],
        ],
      ),
    );
  }

  String _statusLabel(KycStepStatus status) => switch (status) {
    KycStepStatus.notStarted => 'Not started',
    KycStepStatus.pending => 'Pending',
    KycStepStatus.verified => 'Verified',
    KycStepStatus.rejected => 'Rejected',
  };
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.index,
    required this.current,
    required this.label,
  });

  final int index;
  final int current;
  final String label;

  @override
  Widget build(BuildContext context) {
    final active = index <= current;
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: active ? AppColors.emerald : AppColors.line,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: active ? AppColors.white : AppColors.navy,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
