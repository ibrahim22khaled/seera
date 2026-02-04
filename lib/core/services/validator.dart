class Validator {
  static bool isValidName(String name) {
    if (name.trim().isEmpty) return false;
    // Basic name validation: no digits
    return !RegExp(r'\d').hasMatch(name);
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  static bool isValidPhone(String phone) {
    if (phone.trim().isEmpty) return false;
    // Allow digits, +, -, and spaces
    return RegExp(r'^[+0-9\s-]+$').hasMatch(phone.trim());
  }

  static bool isValidUrl(String url) {
    if (url.trim().isEmpty) return false;
    final regex = RegExp(
      r'^(http|https):\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(/\S*)?$',
      caseSensitive: false,
    );
    return regex.hasMatch(url.trim());
  }

  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }

  static bool isValidDateRange(String date) {
    // Expected format: Month Year – Month Year (with en-dash or hyphen)
    // Example: January 2020 – Present or January 2020 – December 2022
    final regex = RegExp(
      r'^[A-Z][a-z]+ \d{4} (–|-) ([A-Z][a-z]+ \d{4}|Present|الحالي)$',
      caseSensitive: false,
    );
    return regex.hasMatch(date.trim());
  }

  static bool isJobTitleNotName(String title) {
    final commonNames = [
      'ahmed',
      'mohamed',
      'ali',
      'hassan',
      'ibrahim',
      'sara',
      'mona',
    ];
    return !commonNames.contains(title.trim().toLowerCase());
  }

  static bool isNameNotJobTitle(String name) {
    final commonJobs = [
      'engineer',
      'doctor',
      'teacher',
      'developer',
      'manager',
      'مهندس',
      'دكتور',
      'مطور',
    ];
    return !commonJobs.contains(name.trim().toLowerCase());
  }

  static String? validateField(String fieldName, String value) {
    switch (fieldName.toLowerCase()) {
      case 'name':
      case 'fullname':
        if (!isValidName(value)) {
          return 'الاسم غير صحيح، يرجى كتابة اسم حقيقي بدون أرقام.';
        }
        if (!isNameNotJobTitle(value)) {
          return 'الاسم لا يجب أن يكون مسمى وظيفي.';
        }
        return null;
      case 'email':
        return isValidEmail(value) ? null : 'البريد الإلكتروني غير صحيح.';
      case 'phone':
        return isValidPhone(value) ? null : 'رقم الهاتف غير صحيح.';
      case 'jobtitle':
        if (!isNotEmpty(value)) return 'القيمة لا يمكن أن تكون فارغة.';
        if (!isJobTitleNotName(value)) {
          return 'المسمى الوظيفي لا يجب أن يكون اسماً.';
        }
        return null;
      case 'duration':
        return isNotEmpty(value) ? null : 'القيمة لا يمكن أن تكون فارغة.';
      case 'country':
      case 'city':
      case 'role':
      case 'company':
        return isNotEmpty(value) ? null : 'القيمة لا يمكن أن تكون فارغة.';
      case 'link':
      case 'attachment':
        return isValidUrl(value) ? null : 'الرابط غير صحيح.';
      default:
        return null;
    }
  }
}
