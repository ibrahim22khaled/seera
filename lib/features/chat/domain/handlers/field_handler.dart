import 'package:seera/generated/l10n/app_localizations.dart';
import 'package:seera/core/services/validator.dart';

class FieldHandler {
  String? currentField;

  final Map<String, List<String>> _fieldKeywords = {
    'jobType': [
      'وظيفة',
      'نوع',
      'tech',
      'blue_collar',
      'blue collar',
      'service',
      'job',
      'type',
    ],
    'name': ['اسم', 'name', 'fullname'],
    'email': ['بريد', 'email', 'mail'],
    'phone': ['هاتف', 'تليفون', 'phone', 'mobile'],
    'country': ['بلد', 'دولة', 'country'],
    'city': ['مدينة', 'city', 'location'],
    'jobtitle': ['وظيفة', 'مسمى', 'role', 'job'],
    'experience': ['خبرة', 'experience', 'work'],
    'education': ['تعليم', 'دراسة', 'education', 'study'],
    'languages': ['لغات', 'languages'],
  };

  /// Detects which field the user is likely checking or referring to
  String? detectField(String text) {
    for (var entry in _fieldKeywords.entries) {
      for (var keyword in entry.value) {
        if (text.toLowerCase().contains(keyword.toLowerCase())) {
          return entry.key;
        }
      }
    }
    return null;
  }

  /// Validates the input based on the detected or expected field
  String? validate(String field, String value, AppLocalizations loc) {
    // Basic normalization
    final val = value.trim();
    // Use the central Validator
    return Validator.validateField(field, val, loc);
  }
}
