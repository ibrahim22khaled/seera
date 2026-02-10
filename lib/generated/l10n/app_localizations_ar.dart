// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'سيرة';

  @override
  String get welcomeBack => 'أهلاً بك مجدداً';

  @override
  String get loginSubtitle =>
      'سجل دخولك لإنشاء سيرتك الذاتية المتوافقة مع الـ ATS';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get orContinueWith => 'أو استمر باستخدام';

  @override
  String get google => 'جوجل';

  @override
  String get apple => 'أبل';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get chatToBuildCV => 'دردشة لبناء سيرتك الذاتية';

  @override
  String get chatSubtitle =>
      'جاوب على أسئلة بسيطة والذكاء الاصطناعي هيصمم لك CV احترافي في دقائق.';

  @override
  String get continueText => 'استمرار';

  @override
  String get skip => 'تخطي';

  @override
  String get previewPdf => 'معاينة PDF';

  @override
  String get online => 'متصل';

  @override
  String get typeYourResponse => 'اكتب ردك هنا...';

  @override
  String get chat => 'الدردشة';

  @override
  String get resumes => 'السير الذاتية';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get sendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get enterEmailToReset =>
      'أدخل بريدك الإلكتروني لتلقي رابط إعادة تعيين كلمة المرور. سنساعدك في استعادة الوصول إلى حسابك.';

  @override
  String get emailAddress => 'عنوان البريد الإلكتروني';

  @override
  String get enterEmail => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get resetLinkSent =>
      'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني';

  @override
  String get resetFailed => 'فشل إعادة التعيين';

  @override
  String get rememberPassword => 'هل تتذكر كلمة المرور؟';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String welcomeToSeera(Object name) {
    return 'أهلاً بك في سيرة، $name!';
  }

  @override
  String get registrationFailed => 'فشل إنشاء الحساب';

  @override
  String get joinSeera => 'انضم إلى سيرة';

  @override
  String get fullName => 'الاسم بالكامل';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get aiSettings => 'إعدادات الذكاء الاصطناعي';

  @override
  String get primaryLanguage => 'اللغة الأساسية';

  @override
  String get preferredAiDialect => 'اللهجة المفضلة للذكاء الاصطناعي';

  @override
  String get toneSetting => 'إعدادات النبرة';

  @override
  String get slangEnglish => 'الإنجليزية العامية';

  @override
  String get egyptianArabic => 'العامية المصرية';

  @override
  String get saudiArabic => 'العامية السعودية';

  @override
  String get alreadyHaveAccount => 'هل لديك حساب بالفعل؟';

  @override
  String get required => 'مطلوب';

  @override
  String get pleaseFillAllFields => 'يرجى ملء جميع الحقول';

  @override
  String get loginSuccessful => 'تم تسجيل الدخول بنجاح';

  @override
  String get loginFailed => 'فشل تسجيل الدخول';

  @override
  String googleSignInFailed(Object error) {
    return 'فشل تسجيل الدخول باستخدام جوجل: $error';
  }

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get guestUser => 'مستخدم زائر';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get internalError => 'حدث خطأ داخلي. يرجى المحاولة مرة أخرى لاحقاً.';

  @override
  String get networkError => 'خطأ في الشبكة. يرجى التحقق من اتصالك بالإنترنت.';
}
