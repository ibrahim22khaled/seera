import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seera/core/theme/app_theme.dart';
import 'package:seera/generated/l10n/app_localizations.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isChecking = false;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _sendVerificationEmail();
  }

  Future<void> _sendVerificationEmail() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      debugPrint('Error sending verification email: $e');
    }
  }

  Future<void> _checkVerificationStatus() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isChecking = true);
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        if (_auth.currentUser!.emailVerified) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/chat');
          }
        } else {
          Fluttertoast.showToast(
            msg: l10n.emailNotVerifiedYet,
            backgroundColor: Colors.orange,
          );
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = _auth.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                size: 80,
                color: AppTheme.primaryBlue,
              ),
              const SizedBox(height: 32),
              Text(
                l10n.verifyEmail,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.emailVerificationInstructions(user?.email ?? ""),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              _isChecking
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _checkVerificationStatus,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          l10n.checkVerificationStatus,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: _sendVerificationEmail,
                child: Text(
                  l10n.resendLink,
                  style: const TextStyle(color: AppTheme.primaryBlue),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () async {
                  await _auth.signOut();
                  if (mounted)
                    Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text(
                  l10n.signOut,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
