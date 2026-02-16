import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seera/core/theme/app_theme.dart';
import 'package:seera/generated/l10n/app_localizations.dart';
import 'package:seera/core/services/locale_cubit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/logo.png',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          l10n.appTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _navigateHome,
            child: Text(
              l10n.skip,
              style: const TextStyle(color: AppTheme.textMuted),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildChatPreview(),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Text(
                    l10n.chatToBuildCV,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.chatSubtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textMuted,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Spacer(),
            // _buildPageIndicator(),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: _navigateHome,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.continueText),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildLanguageToggle(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildChatPreview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildPreviewBubble(
            'SEERA AI',
            'Hello! I\'m here to help you build your dream CV. Ready to get started?',
            false,
          ),
          const SizedBox(height: 16),
          _buildPreviewBubble('YOU', 'Yes, let\'s do it!', true),
          const SizedBox(height: 16),
          _buildPreviewBubble(
            'SEERA AI',
            'Great! Let\'s start with your work history. What was your most recent job title?',
            false,
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 48),
              child: Text(
                '...',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewBubble(String sender, String text, bool isUser) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        if (!isUser) ...[
          CircleAvatar(
            radius: 12,
            backgroundColor: AppTheme.primaryBlue.withOpacity(0.2),
            child: const Icon(
              Icons.smart_toy,
              size: 12,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment: isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                sender,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isUser ? AppTheme.primaryBlue : AppTheme.aiBubbleBg,
                  borderRadius: BorderRadius.circular(12).copyWith(
                    bottomLeft: isUser
                        ? const Radius.circular(12)
                        : const Radius.circular(0),
                    bottomRight: isUser
                        ? const Radius.circular(0)
                        : const Radius.circular(12),
                  ),
                ),
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildPageIndicator() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: List.generate(3, (index) {
  //       return Container(
  //         width: index == 0 ? 32 : 8,
  //         height: 4,
  //         margin: const EdgeInsets.symmetric(horizontal: 4),
  //         decoration: BoxDecoration(
  //           color: index == 0 ? AppTheme.primaryBlue : AppTheme.surfaceBg,
  //           borderRadius: BorderRadius.circular(2),
  //         ),
  //       );
  //     }),
  //   );
  // }

  Widget _buildLanguageToggle(BuildContext context) {
    final localeCubit = context.watch<LocaleCubit>();
    final currentLocale = localeCubit.state;

    return InkWell(
      onTap: () => localeCubit.toggleLocale(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.public, color: AppTheme.textMuted, size: 18),
          const SizedBox(width: 8),
          Text(
            currentLocale.languageCode == 'ar' ? 'English (US)' : 'العربية',
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateHome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_onboarding', false);
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/chat');
    }
  }
}
