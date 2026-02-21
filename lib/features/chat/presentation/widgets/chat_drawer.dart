import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seera/core/theme/app_theme.dart';
import 'package:seera/generated/l10n/app_localizations.dart';
import '../cubit/chat_cubit.dart';

class ChatDrawer extends StatelessWidget {
  const ChatDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: AppTheme.darkBg,
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          final user = FirebaseAuth.instance.currentUser;
          return Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: AppTheme.surfaceBg),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.appTitle.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      if (user != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          user.email ?? user.displayName ?? '',
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 8),
                        Text(
                          l10n.guestUser,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.add, color: Colors.blue),
                title: Text(
                  l10n.startNewChat,
                  style: const TextStyle(color: Colors.white),
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
                        session.title == '__new_chat__'
                            ? l10n.newChat
                            : session.title,
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
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              backgroundColor: AppTheme.surfaceBg,
                              title: Text(
                                l10n.deleteConversation,
                                style: const TextStyle(color: Colors.white),
                              ),
                              content: Text(
                                l10n.deleteConfirmation,
                                style: const TextStyle(
                                  color: AppTheme.textMuted,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: Text(l10n.cancel),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<ChatCubit>().deleteSession(
                                      session.id,
                                    );
                                    Navigator.pop(dialogContext);
                                  },
                                  child: Text(
                                    l10n.delete,
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
              const Divider(color: AppTheme.textMuted),
              if (user == null)
                ListTile(
                  leading: const Icon(Icons.login, color: Colors.green),
                  title: Text(
                    l10n.login,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                )
              else
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: Text(
                    l10n.signOut,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Fluttertoast.showToast(msg: l10n.signedOut);
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
