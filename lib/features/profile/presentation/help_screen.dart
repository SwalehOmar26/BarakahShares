import 'package:flutter/material.dart';

import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/state_views.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help and support')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const DemoNotice(
            message: 'Support messages are not delivered from this build.',
          ),
          const SizedBox(height: 12),
          const _Faq(
            question: 'Is this a live investment?',
            answer: 'No. Amounts, certificates, and payments in this app are demonstration data until the NestJS backend is connected.',
          ),
          const _Faq(
            question: 'Does M-Pesa run here?',
            answer: 'No STK push is sent. The checkout only records the result you explicitly simulate.',
          ),
          const _Faq(
            question: 'Can the assistant approve a contribution?',
            answer: 'No. Barakah AI explains the sample data. It does not approve payments or issue Shariah rulings.',
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => showInfoDialog(
              context,
              title: 'Contact',
              message: 'In-app support is not connected yet. Keep questions inside the demonstration assistant for now.',
            ),
            child: const Text('Contact support'),
          ),
        ],
      ),
    );
  }
}

class _Faq extends StatelessWidget {
  const _Faq({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(question),
      children: [Align(alignment: Alignment.centerLeft, child: Text(answer))],
    );
  }
}
