// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Seera';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get loginSubtitle => 'Log in to generate your ATS-friendly CV';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get login => 'Login';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get chatToBuildCV => 'Chat to build your CV';

  @override
  String get chatSubtitle =>
      'Answer simple questions and our AI will craft a professional, ATS-friendly resume for you in minutes.';

  @override
  String get continueText => 'Continue';

  @override
  String get skip => 'Skip';

  @override
  String get previewPdf => 'PREVIEW PDF';

  @override
  String get online => 'ONLINE';

  @override
  String get typeYourResponse => 'Type your response...';

  @override
  String get chat => 'Chat';

  @override
  String get resumes => 'Resumes';

  @override
  String get profile => 'Profile';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get enterEmailToReset =>
      'Enter your email to receive a password reset link. We\'ll help you get back into your account.';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get enterEmail => 'Please enter your email';

  @override
  String get resetLinkSent => 'Password reset link sent to your email';

  @override
  String get resetFailed => 'Reset failed';

  @override
  String get rememberPassword => 'Remember your password?';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String welcomeToSeera(Object name) {
    return 'Welcome to Seera, $name!';
  }

  @override
  String get registrationFailed => 'Registration failed';

  @override
  String get joinSeera => 'Join Seera';

  @override
  String get fullName => 'Full Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get aiSettings => 'AI Settings';

  @override
  String get primaryLanguage => 'Primary Language';

  @override
  String get preferredAiDialect => 'Preferred AI Dialect';

  @override
  String get toneSetting => 'TONE SETTING';

  @override
  String get slangEnglish => 'Slang English';

  @override
  String get egyptianArabic => 'Egyptian Arabic';

  @override
  String get saudiArabic => 'Saudi Arabic';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get required => 'Required';

  @override
  String get pleaseFillAllFields => 'Please fill all fields';

  @override
  String get loginSuccessful => 'Login Successful';

  @override
  String get loginFailed => 'Login failed';

  @override
  String googleSignInFailed(Object error) {
    return 'Google Sign-In failed: $error';
  }

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get guestUser => 'Guest User';

  @override
  String get signOut => 'Sign Out';

  @override
  String get internalError =>
      'An internal error occurred. Please try again later.';

  @override
  String get networkError =>
      'Network error. Please check your internet connection.';
}
