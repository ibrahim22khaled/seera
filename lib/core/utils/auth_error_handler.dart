import 'package:firebase_auth/firebase_auth.dart';
import 'package:seera/generated/l10n/app_localizations.dart';

class AuthErrorHandler {
  static String getMessage(FirebaseAuthException e, AppLocalizations l10n) {
    switch (e.code) {
      case 'internal-error':
        return l10n.internalError;
      case 'network-request-failed':
        return l10n.networkError;
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.'; // Add to ARB if needed
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'configuration-not-found':
      case 'user-not-found':
        return 'This account is not signed in';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return e.message ?? l10n.internalError;
    }
  }
}
