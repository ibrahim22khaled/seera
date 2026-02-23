import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seera/core/theme/app_theme.dart';
import 'package:seera/features/cv_builder/presentation/pages/review_cv_screen.dart';
import 'package:seera/generated/l10n/app_localizations.dart';
import '../cubit/chat_cubit.dart';
import '../widgets/chat_drawer.dart';
import '../widgets/chat_input_section.dart';
import '../widgets/chat_message_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: ChatScreenContent());
  }
}

class ChatScreenContent extends StatelessWidget {
  const ChatScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(l10n, theme),
        actions: [_buildPreviewButton(context, l10n)],
      ),
      drawer: const ChatDrawer(),
      body: _buildBody(context, controller, l10n),
    );
  }

  Widget _buildAppBarTitle(AppLocalizations l10n, ThemeData theme) {
    return Column(
      children: [
        Text("${l10n.appTitle} AI Builder"),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.circle, color: Colors.green, size: 8),
            const SizedBox(width: 4),
            Text(
              l10n.online,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreviewButton(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: TextButton(
        onPressed: () => context.read<ChatCubit>().generateCV(l10n),
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Text(
          l10n.previewPdf,
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    TextEditingController controller,
    AppLocalizations l10n,
  ) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) => _handleStateChanges(context, state, l10n),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          return Column(
            children: [
              _buildTodayHeader(l10n),
              Expanded(child: _buildMessagesList(state, l10n)),
              ChatInputSection(
                controller: controller,
                l10n: l10n,
                state: state,
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleStateChanges(
    BuildContext context,
    ChatState state,
    AppLocalizations l10n,
  ) {
    if (state is ChatReview) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ReviewCvScreen(messages: state.messages, cvData: state.cvData),
        ),
      );
    } else if (state is ChatError) {
      _showError(context, state, l10n);
    }
  }

  void _showError(
    BuildContext context,
    ChatError state,
    AppLocalizations l10n,
  ) {
    final msg = state.message.toLowerCase();
    if (msg.contains('limit') || msg.contains('429') || msg.contains('rate')) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.surfaceBg,
          title: Text(
            l10n.aiLimitReached,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            l10n.aiLimitReached, // Using same key for now as it contains the limit message usually, but let's be safe.
            style: const TextStyle(color: AppTheme.textMuted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pushNamed(
                  context,
                  '/manual-form',
                ); // Navigate to manual
              },
              child: Text(l10n.manualMode),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Widget _buildTodayHeader(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.surfaceBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          l10n.today,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesList(ChatState state, AppLocalizations l10n) {
    if (state is ChatInitial) {
      return Center(child: Text(l10n.startChatting));
    } else if (state is ChatLoading && state.sessions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final messages = _getMessagesFromState(state);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isUser = msg.startsWith('You:');
        return ChatMessageBubble(message: msg, isUser: isUser);
      },
    );
  }

  List<String> _getMessagesFromState(ChatState state) {
    if (state is ChatLoaded) return state.messages;
    if (state is ChatReview) return state.messages;
    if (state is ChatError) return state.messages;
    return [];
  }
}
