import 'package:flutter/material.dart';
import 'package:seera/core/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seera/generated/l10n/app_localizations.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Choose Download Option'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Unlock your professional CV',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Choose the best format for your career success',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildOptionCard(
              context: context,
              title: 'Free Download',
              features: ['Seera watermark included', 'Standard PDF format'],
              buttonLabel: 'Download ...',
              isRecommended: false,
            ),
            const SizedBox(height: 24),
            _buildOptionCard(
              context: context,
              title: 'Premium Download',
              features: [
                'Official & ATS Optimized',
                'No watermark • High priority formatting',
                'Unlimited future edits',
              ],
              buttonLabel: 'Pay \$9.99 & Download',
              isRecommended: true,
            ),
            const SizedBox(height: 48),
            const Text(
              'SECURE PAYMENT METHODS',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.credit_card, color: AppTheme.textMuted),
                SizedBox(width: 24),
                Icon(Icons.account_balance_wallet, color: AppTheme.textMuted),
                SizedBox(width: 24),
                Icon(Icons.tap_and_play, color: AppTheme.textMuted),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'By upgrading, you agree to our Terms of Service. Secure 256-bit SSL encrypted payment processing.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textMuted, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required String title,
    required List<String> features,
    required String buttonLabel,
    required bool isRecommended,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceBg,
        borderRadius: BorderRadius.circular(24),
        border: isRecommended
            ? Border.all(color: AppTheme.primaryBlue, width: 2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://via.placeholder.com/400x200',
                    ), // Replace with actual preview image
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'WATERMARKED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              if (isRecommended)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'RECOMMENDED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ...features.map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          isRecommended ? Icons.check_circle : Icons.close,
                          size: 16,
                          color: isRecommended
                              ? AppTheme.primaryBlue
                              : AppTheme.textMuted,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          f,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      final l10n = AppLocalizations.of(context)!;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.pleaseLoginToPrint),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                      Navigator.pushNamed(context, '/login');
                      return;
                    }
                    // Handle download logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRecommended
                        ? AppTheme.primaryBlue
                        : Colors.transparent,
                    foregroundColor: Colors.white,
                    side: isRecommended
                        ? null
                        : const BorderSide(color: AppTheme.textMuted),
                  ),
                  child: Text(buttonLabel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
