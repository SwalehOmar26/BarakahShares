import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/state_views.dart';
import '../../../shared/providers/providers.dart';

class AiMessage {
  const AiMessage({required this.text, required this.fromUser});

  final String text;
  final bool fromUser;
}

class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({this.businessId, super.key});

  final String? businessId;

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  final _input = TextEditingController();
  final _messages = <AiMessage>[
    const AiMessage(
      text: 'Ask about a demonstration campaign. I explain the sample figures only.',
      fromUser: false,
    ),
  ];
  var _busy = false;

  static const _prompts = [
    'Explain this investment.',
    'What are the risks?',
    'How does Musharakah work?',
    'Where is my money going?',
    'Explain my profit allocation.',
    'Summarize this business\'s financial performance.',
  ];

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _ask(String question) async {
    final trimmed = question.trim();
    if (trimmed.isEmpty || _busy) return;
    setState(() {
      _busy = true;
      _messages.add(AiMessage(text: trimmed, fromUser: true));
      _input.clear();
    });
    try {
      final userId = ref.read(authControllerProvider).user?.id ?? 'guest';
      final answer = await ref
          .read(aiRepositoryProvider)
          .ask(
            question: trimmed,
            businessId: widget.businessId,
            userId: userId,
          );
      if (!mounted) return;
      setState(() => _messages.add(AiMessage(text: answer, fromUser: false)));
    } on Object catch (error) {
      if (!mounted) return;
      setState(
        () => _messages.add(AiMessage(text: error.toString(), fromUser: false)),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final business = widget.businessId == null
        ? null
        : ref.watch(campaignProvider(widget.businessId!)).asData?.value;
    return Scaffold(
      appBar: AppBar(title: const Text('Barakah AI')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: DemoNotice(
              message: business == null
                  ? AppConstants.disclaimerAi
                  : '${AppConstants.disclaimerAi} Context: ${business.name}.',
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 42,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _prompts.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return ActionChip(
                  label: Text(_prompts[index]),
                  onPressed: _busy ? null : () => _ask(_prompts[index]),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length + (_busy ? 1 : 0),
              itemBuilder: (context, index) {
                if (_busy && index == _messages.length) {
                  return const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.emerald,
                      ),
                    ),
                  );
                }
                final message = _messages[index];
                return Align(
                  alignment: message.fromUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    constraints: const BoxConstraints(maxWidth: 460),
                    decoration: BoxDecoration(
                      color: message.fromUser
                          ? AppColors.emerald
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      message.text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: message.fromUser
                            ? AppColors.white
                            : AppColors.ink,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      decoration: const InputDecoration(
                        hintText: 'Ask about the demonstration',
                      ),
                      onSubmitted: _ask,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.emerald,
                      foregroundColor: AppColors.white,
                    ),
                    onPressed: _busy ? null : () => _ask(_input.text),
                    icon: const Icon(Icons.send_rounded),
                    tooltip: 'Send',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
