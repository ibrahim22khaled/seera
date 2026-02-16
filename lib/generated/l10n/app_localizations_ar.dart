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
  String get langSettings => 'إعدادات اللغة';

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

  @override
  String get cvCreatedSuccess => 'تم إنشاء السيرة الذاتية بنجاح!';

  @override
  String printingError(Object error) {
    return 'حصل مشكلة في الطباعة: $error';
  }

  @override
  String get micPermissionError =>
      'المايك محتاج صلاحيات. روح للإعدادات وفعّل صلاحية المايكروفون.';

  @override
  String get micInitError =>
      'مش قادرين نشغل المايك. جرب تقفل البرنامج وتفتحه تاني.';

  @override
  String micGenericError(Object error) {
    return 'حصلت مشكلة في المايك: $error';
  }

  @override
  String get micNotWorking =>
      'المايك مش شغال يا بطل، اتأكد من الصلاحيات أو جرب تكتب.';

  @override
  String galleryImageAttached(Object name) {
    return 'صورة من المعرض: $name';
  }

  @override
  String get imageSavedAI =>
      'تمام، تم حفظ الصورة كنموذج أعمال. هل فيه حاجة تانية حابب تضيفها؟';

  @override
  String get fileOpenError =>
      'مش قادرين نفتح الملفات. لو لسه ضايف الميزة دي، لازم تقفل البرنامج وتفتحه تاني (Full Restart) عشان تشتغل.';

  @override
  String connectionError(Object error) {
    return 'حصل مشكلة في الاتصال: $error';
  }

  @override
  String dataCollectionError(Object error) {
    return 'حصل مشكلة واحنا بنجمع بياناتك: $error';
  }

  @override
  String get missingBasicInfo =>
      'لسه محتاجين نجمع باقي البيانات الأساسية (الاسم، البريد، الهاتف، المسمى الوظيفي) عشان نقدر نعمل الـ CV.';

  @override
  String get cvReady => 'تم تجهيز الـ CV يا بطل! ربنا يوفقك.';

  @override
  String get newChat => 'محادثة جديدة';

  @override
  String get startNewChat => 'بدء محادثة جديدة';

  @override
  String get deleteConversation => 'حذف المحادثة؟';

  @override
  String get deleteConfirmation =>
      'هل أنت متأكد أنك تريد حذف هذه المحادثة؟ لا يمكن التراجع عن هذا الفعل.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get signedOut => 'تم تسجيل الخروج';

  @override
  String get today => 'اليوم';

  @override
  String get startChatting => 'ابدأ المحادثة لبناء سيرتك الذاتية!';

  @override
  String get summaryPlaceholder => 'اكتب الملخص الوظيفي هنا بشكل مفصل...';

  @override
  String get saveSummary => 'حفظ الملخص';

  @override
  String get addSkillsInstruction => 'أضف مهاراتك واحدة تلو الأخرى:';

  @override
  String get skillsPlaceholder => 'مثلاً: Flutter, UI Design...';

  @override
  String get finishedAddingSkills => 'انتهيت من إضافة المهارات';

  @override
  String get doneWithSkills => 'انتهيت من المهارات';

  @override
  String get selectLanguageLevel => 'اختر مستوى الإجادة للغة:';

  @override
  String get beginner => 'مبتدئ';

  @override
  String get intermediate => 'متوسط';

  @override
  String get advanced => 'متقدم';

  @override
  String get native => 'لغة أم';

  @override
  String get reviewData => 'راجع بياناتك';

  @override
  String get basicInfo => 'المعلومات الأساسية';

  @override
  String get fullNameLabel => 'الاسم بالكامل';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get phoneLabel => 'رقم التليفون';

  @override
  String get cityLabel => 'المدينة';

  @override
  String get countryLabel => 'الدولة';

  @override
  String get targetCountryLabel => 'الدولة المستهدفة';

  @override
  String get jobTitleLabel => 'المسمى الوظيفي';

  @override
  String get summaryLabel => 'نبذة مختصرة';

  @override
  String get experienceSection => 'الخبرات العملية';

  @override
  String get educationSection => 'التعليم';

  @override
  String get skillsSection => 'المهارات';

  @override
  String get languagesSection => 'اللغات';

  @override
  String get projectsSection => 'المشاريع / Portfolio';

  @override
  String get additionalInfoSection => 'معلومات إضافية';

  @override
  String get additionalInfoPlaceholder => 'أي معلومات أخرى';

  @override
  String get addExperience => 'إضافة خبرة';

  @override
  String get addWorkExperience => 'إضافة خبرة عملية';

  @override
  String get add => 'إضافة';

  @override
  String get save => 'حفظ';

  @override
  String get edit => 'تعديل';

  @override
  String get editExperience => 'تعديل خبرة';

  @override
  String get jobTitleField => 'المسمى الوظيفي';

  @override
  String get companyField => 'الشركة';

  @override
  String get locationField => 'المكان';

  @override
  String get durationField => 'المدة (مثلاً: ٢٠٢٠ - ٢٠٢٢)';

  @override
  String get responsibilitiesField => 'المهام (افصل بـ -)';

  @override
  String get portfolioLinksField => 'روابط أعمال (افصل بـ space)';

  @override
  String get portfolioLabel => 'نماذج الأعمال / روابط:';

  @override
  String get addEducation => 'إضافة تعليم';

  @override
  String get degreeField => 'الدرجة العلمية';

  @override
  String get institutionField => 'المؤسسة';

  @override
  String get periodField => 'الفترة';

  @override
  String get addSkill => 'إضافة مهارة';

  @override
  String get addLanguage => 'إضافة لغة';

  @override
  String get languageField => 'اللغة';

  @override
  String get levelField => 'المستوى';

  @override
  String get addProject => 'إضافة مشروع';

  @override
  String get addProjectLink => 'إضافة مشروع / رابط';

  @override
  String get titleField => 'العنوان';

  @override
  String get linkField => 'الرابط';

  @override
  String get chooseCVMethod => 'اختر طريقة بناء السيرة الذاتية';

  @override
  String get aiChatMode => 'مساعد الذكاء الاصطناعي';

  @override
  String get aiChatDescription =>
      'خلي الذكاء الاصطناعي يساعدك في بناء سيرتك الذاتية بمحادثة بسيطة';

  @override
  String get manualMode => 'نموذج يدوي';

  @override
  String get manualDescription =>
      'ابني سيرتك الذاتية بنفسك مع تحكم كامل في كل التفاصيل';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get noSavedCVs => 'لا يوجد سير ذاتية محفوظة بعد';

  @override
  String get searchPlaceholder => 'ابحث في سيرتك الذاتية...';

  @override
  String get view => 'معاينة';

  @override
  String get pdf => 'PDF';

  @override
  String get unknownDate => 'تاريخ غير معروف';

  @override
  String get darkMode => 'الوضع الليلي';

  @override
  String get premiumPlan => 'الخطة المميزة';

  @override
  String get active => 'نشط';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get version => 'الإصدار';

  @override
  String get linkedinLabel => 'حساب LinkedIn';

  @override
  String get githubLabel => 'حساب GitHub';

  @override
  String get customSections => 'أقسام إضافية';

  @override
  String get addCustomSection => 'إضافة قسم خاص';

  @override
  String get sectionTitle => 'عنوان القسم';

  @override
  String get sectionContent => 'محتوى القسم';

  @override
  String get reorderSections => 'Reorder Sections';

  @override
  String get projectRole => 'Role (e.g., Team Lead)';

  @override
  String get projectDescription => 'Project Description';

  @override
  String get noResultsFound => 'لا يوجد نتائج';

  @override
  String get editProject => 'Edit Project';

  @override
  String get invalidName => 'الاسم غير صحيح، يرجى كتابة اسم حقيقي.';

  @override
  String get invalidEmail => 'البريد الإلكتروني غير صحيح.';

  @override
  String get invalidPhone => 'رقم الهاتف غير صحيح.';

  @override
  String get invalidUrl => 'الرابط غير صحيح.';

  @override
  String get fieldRequired => 'القيمة لا يمكن أن تكون فارغة.';
}
