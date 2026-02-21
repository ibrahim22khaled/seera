import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seera/core/theme/app_theme.dart';
import 'package:seera/generated/l10n/app_localizations.dart';
import '../cubit/chat_cubit.dart';
import 'animated_wave_bar.dart';

class ChatInputSection extends StatelessWidget {
  final TextEditingController controller;
  final AppLocalizations l10n;
  final ChatState state;

  const ChatInputSection({
    super.key,
    required this.controller,
    required this.l10n,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    bool isListening = false;
    String? currentField;
    final currentState = state;
    if (currentState is ChatLoaded) {
      isListening = currentState.isListening;
      currentField = currentState.currentField;
    } else {
      currentField = state.currentField;
    }

    if (isListening) {
      return _buildVoiceRecordingUI(context);
    }

    if (currentField == 'summary') {
      return _buildSummaryInput(context);
    } else if (currentField == 'skills') {
      return _buildSkillsInput(context);
    } else if (currentField == 'language') {
      return _buildLanguageInput(context);
    }

    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPadding),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: l10n.typeYourResponse,
                filled: true,
                fillColor: AppTheme.surfaceBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context.read<ChatCubit>().sendMessage(controller.text, l10n);
                  controller.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceRecordingUI(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomPadding),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          const Icon(Icons.mic, color: Colors.redAccent, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(15, (index) {
                  return AnimatedWaveBar(index: index);
                }),
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(
              Icons.stop_circle,
              color: Colors.redAccent,
              size: 40,
            ),
            onPressed: () => context.read<ChatCubit>().toggleListening(
              l10n,
              Localizations.localeOf(context).languageCode,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryInput(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPadding),
      child: Column(
        children: [
          TextField(
            controller: controller,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'اكتب الملخص الوظيفي هنا بشكل مفصل...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<ChatCubit>().sendMessage(controller.text, l10n);
                controller.clear();
              }
            },
            child: Text(l10n.saveSummary),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsInput(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.addSkillsInstruction,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'مثلاً: Flutter, UI Design...',
                    prefixIcon: const Icon(
                      Icons.circle,
                      size: 8,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.blue,
                  size: 32,
                ),
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    context.read<ChatCubit>().sendMessage(
                      controller.text,
                      l10n,
                    );
                    controller.clear();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.read<ChatCubit>().sendMessage(
              l10n.doneWithSkills,
              l10n,
            ),
            child: Text(
              l10n.finishedAddingSkills,
              style: const TextStyle(color: AppTheme.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageInput(BuildContext context) {
    final levels = [
      l10n.beginner,
      l10n.intermediate,
      l10n.advanced,
      l10n.native,
    ];

    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.selectLanguageLevel,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: levels.map((level) {
              return ActionChip(
                label: Text(level),
                backgroundColor: AppTheme.surfaceBg,
                labelStyle: const TextStyle(color: Colors.white),
                onPressed: () {
                  context.read<ChatCubit>().sendMessage(level, l10n);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
