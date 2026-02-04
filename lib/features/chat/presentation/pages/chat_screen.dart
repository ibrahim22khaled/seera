import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seera/core/theme/app_theme.dart';
import 'package:seera/features/cv_builder/presentation/pages/review_cv_screen.dart';
import 'package:seera/generated/l10n/app_localizations.dart';
import '../cubit/chat_cubit.dart';

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
        title: Column(
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
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () => context.read<ChatCubit>().generateCV(),
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
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppTheme.darkBg,
        child: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            return Column(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: AppTheme.surfaceBg),
                  child: Center(
                    child: Text(
                      l10n.appTitle.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.add, color: Colors.blue),
                  title: const Text(
                    'بدء محادثة جديدة',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    context.read<ChatCubit>().createNewSession();
                    Navigator.pop(context);
                  },
                ),
                const Divider(
                  color: AppTheme.textMuted,
                  indent: 16,
                  endIndent: 16,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: state.sessions.length,
                    itemBuilder: (context, index) {
                      final session = state.sessions[index];
                      final isSelected = session.id == state.currentSessionId;
                      return ListTile(
                        leading: Icon(
                          Icons.chat_bubble_outline,
                          color: isSelected ? Colors.blue : AppTheme.textMuted,
                          size: 20,
                        ),
                        title: Text(
                          session.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isSelected ? Colors.blue : Colors.white,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          color: Colors.redAccent.withOpacity(0.7),
                          onPressed: () => context
                              .read<ChatCubit>()
                              .deleteSession(session.id),
                        ),
                        selected: isSelected,
                        onTap: () {
                          context.read<ChatCubit>().switchSession(session.id);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: BlocListener<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatReview) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewCvScreen(
                  messages: state.messages,
                  cvData: state.cvData,
                ),
              ),
            );
          } else if (state is ChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'TODAY',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(child: _buildMessagesList(state)),
                _buildInputArea(context, controller, l10n, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessagesList(ChatState state) {
    if (state is ChatInitial) {
      return const Center(child: Text('Start chatting to build your CV!'));
    } else if (state is ChatLoading && state.sessions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final messages = (state is ChatLoaded)
        ? state.messages
        : (state is ChatReview)
        ? state.messages
        : (state is ChatError)
        ? state.messages
        : <String>[];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isUser = msg.startsWith('You:');
        final content = msg.replaceFirst(isUser ? 'You: ' : 'AI: ', '');
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.surfaceBg,
                  child: const Icon(
                    Icons.smart_toy,
                    color: Colors.cyan,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isUser ? AppTheme.primaryBlue : AppTheme.aiBubbleBg,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isUser
                          ? const Radius.circular(16)
                          : Radius.zero,
                      bottomRight: isUser
                          ? Radius.zero
                          : const Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    content,
                    style: const TextStyle(color: Colors.white, height: 1.4),
                  ),
                ),
              ),
              if (isUser) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.surfaceBg,
                  child: const Icon(
                    Icons.person,
                    color: Colors.orange,
                    size: 18,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputArea(
    BuildContext context,
    TextEditingController controller,
    AppLocalizations l10n,
    ChatState state,
  ) {
    bool isListening = false;
    String? currentField;
    if (state is ChatLoaded) {
      isListening = state.isListening;
      currentField = state.currentField;
    }

    if (isListening) {
      return _buildVoiceRecordingUI(context);
    }

    if (currentField == 'summary') {
      return _buildSummaryInput(context, controller, l10n);
    } else if (currentField == 'skills') {
      return _buildSkillsInput(context, controller, l10n);
    } else if (currentField == 'language') {
      return _buildLanguageInput(context, l10n);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.surfaceBg,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: AppTheme.textMuted),
              onPressed: () => context.read<ChatCubit>().pickImage(),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: l10n.typeYourResponse,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.mic_none, color: AppTheme.textMuted),
                  onPressed: () => context.read<ChatCubit>().toggleListening(),
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
                  context.read<ChatCubit>().sendMessage(controller.text);
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
    return Container(
      padding: const EdgeInsets.all(24),
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
            onPressed: () => context.read<ChatCubit>().toggleListening(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryInput(
    BuildContext context,
    TextEditingController controller,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                context.read<ChatCubit>().sendMessage(controller.text);
                controller.clear();
              }
            },
            child: const Text('حفظ الملخص'),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsInput(
    BuildContext context,
    TextEditingController controller,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'أضف مهاراتك واحدة تلو الأخرى:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                    context.read<ChatCubit>().sendMessage(controller.text);
                    controller.clear();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () =>
                context.read<ChatCubit>().sendMessage('انتهيت من المهارات'),
            child: const Text(
              'انتهيت من إضافة المهارات',
              style: TextStyle(color: AppTheme.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageInput(BuildContext context, AppLocalizations l10n) {
    final levels = ['Beginner', 'Intermediate', 'Advanced', 'Native'];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'اختر مستوى الإجادة للغة:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                  context.read<ChatCubit>().sendMessage(level);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class AnimatedWaveBar extends StatefulWidget {
  final int index;
  const AnimatedWaveBar({super.key, required this.index});

  @override
  State<AnimatedWaveBar> createState() => _AnimatedWaveBarState();
}

class _AnimatedWaveBarState extends State<AnimatedWaveBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400 + (widget.index * 100) % 600),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 4, end: 24).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 4,
          height: _animation.value,
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.8),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
    );
  }
}
