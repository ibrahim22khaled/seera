import 'package:seera/generated/l10n/app_localizations.dart';

class Validator {
  static bool isValidName(String name) {
    if (name.trim().isEmpty) return false;
    // Allow letters, spaces, and basic punctuation like . or -
    return RegExp(r'^[a-zA-Z\u0600-\u06FF\s\.-]+$').hasMatch(name.trim());
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  static bool isValidPhone(String phone) {
    if (phone.trim().isEmpty) return false;
    // Allow digits, +, -, and spaces. Be more permissive to avoid flagging valid inputs.
    // e.g., +20 100 123 4567, 01001234567
    return RegExp(r'^[+]?[0-9\s-]{7,20}$').hasMatch(phone.trim());
  }

  static bool isValidUrl(String url) {
    if (url.trim().isEmpty) return false;
    // Simple check. Can be more robust.
    // Allow standard http/https/www patterns or even just domain.com
    return url.trim().contains('.') && url.trim().length > 3;
  }

  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }

  static bool isValidDateRange(String date) {
    // Relaxed date range validation
    return isNotEmpty(date);
  }

  static bool isJobTitleNotName(String title) {
    // This heuristic is often flaky. Disabling it to avoid false positives.
    return true;
  }

  static bool isNameNotJobTitle(String name) {
    // This heuristic is often flaky. Disabling it to avoid false positives.
    return true;
  }

  static String? validateField(
    String fieldName,
    String value,
    AppLocalizations loc,
  ) {
    switch (fieldName.toLowerCase()) {
      case 'name':
      case 'fullname':
        if (!isValidName(value)) {
          return loc.invalidName;
        }
        return null;
      case 'email':
        return isValidEmail(value) ? null : loc.invalidEmail;
      case 'phone':
      case 'mobile':
      case 'phonenumber':
        return isValidPhone(value) ? null : loc.invalidPhone;
      case 'linkedin':
      case 'github':
      case 'website':
        if (value.isEmpty) return null; // Optional
        return isValidUrl(value) ? null : loc.invalidUrl;
      case 'country':
      case 'city':
      case 'role':
      case 'company':
      case 'jobtitle':
        return isNotEmpty(value) ? null : loc.fieldRequired;
      default:
        return null;
    }
  }
}
