import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_copy.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/app_scaffold.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key, required this.page});

  final String page;

  @override
  Widget build(BuildContext context) {
    final content = _pages[page] ?? _pages['about']!;
    return AppScaffold(
      title: content.title,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final paragraph in content.paragraphs) ...[
            Text(paragraph),
            const SizedBox(height: AppSpacing.md),
          ],
          TextButton(onPressed: () => context.pop(), child: const Text('Back')),
        ],
      ),
    );
  }
}

class _Page {
  const _Page(this.title, this.paragraphs);
  final String title;
  final List<String> paragraphs;
}

const _pages = {
  'terms': _Page('Terms', [
    'BarakahShares offers access to vetted equity campaigns. An investment is an ownership stake, not a loan, and a distribution is a share of profit, not interest.',
    'Nothing in this demonstration is an offer to the public, a prospectus, or a promise of profit. Campaigns can fail and distributions can be zero.',
    AppCopy.riskNotice,
  ]),
  'privacy': _Page('Privacy', [
    'Identity documents, selfies, KRA records, and private financial statements stay off public chains.',
    'A verification screen may show a SHA-256 fingerprint and an IPFS content id. Those identifiers are not the document.',
    'This build stores only a demo session token. Supabase keys are read from dart-define and are empty unless you supply them.',
  ]),
  'shariah': _Page('Shariah Compliance', [
    'Campaigns in this demo are labelled when a Shariah review, halal certificate, or audit is marked verified in the sample data.',
    'Profit is allocated by an agreed pool. The app does not describe that allocation as interest or as a guaranteed return.',
    'Zakat figures are informational and are not a fatwa.',
  ]),
  'about': _Page('About BarakahShares', [
    'BarakahShares — Halal Equity Crowd is a youth-investor interface for discovering vetted halal businesses and tracking a fractional equity stake.',
    'This mobile build is a navigable demonstration. Payments, KYC, and chain writes are mocked behind service interfaces.',
    'Amanah as Code.',
  ]),
  'help': _Page('Help & Support', [
    'Demo login: +254700000000 and Demo1234.',
    'Support is not connected in this demo. No message leaves the device.',
    'Use Discover to open a business, then Invest to walk through the simulated M-PESA confirmation.',
  ]),
};
