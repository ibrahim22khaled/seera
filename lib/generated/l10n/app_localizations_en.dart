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
  String get langSettings => 'Language settings';

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

  @override
  String get cvCreatedSuccess => 'CV created successfully!';

  @override
  String printingError(Object error) {
    return 'Error printing CV: $error';
  }

  @override
  String get micPermissionError =>
      'Microphone permission is required. Please enable it in settings.';

  @override
  String get micInitError =>
      'Could not initialize microphone. Please restart the app.';

  @override
  String micGenericError(Object error) {
    return 'Microphone error: $error';
  }

  @override
  String get micNotWorking =>
      'Microphone is not working, please check permissions or type instead.';

  @override
  String galleryImageAttached(Object name) {
    return 'Image from gallery: $name';
  }

  @override
  String get imageSavedAI =>
      'Image saved as work sample. Anything else to add?';

  @override
  String get fileOpenError =>
      'Could not open files. If you just added this feature, a full restart is required.';

  @override
  String connectionError(Object error) {
    return 'Connection error: $error';
  }

  @override
  String dataCollectionError(Object error) {
    return 'Error collecting your data: $error';
  }

  @override
  String get missingBasicInfo =>
      'We still need basic info (Name, Email, Phone, Job Title) to generate the CV.';

  @override
  String get cvReady => 'CV is ready! Good luck.';

  @override
  String get newChat => 'New Chat';

  @override
  String get startNewChat => 'Start New Chat';

  @override
  String get deleteConversation => 'Delete Conversation?';

  @override
  String get deleteConfirmation =>
      'Are you sure you want to delete this conversation? This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get signedOut => 'You signed out';

  @override
  String get today => 'TODAY';

  @override
  String get startChatting => 'Start chatting to build your CV!';

  @override
  String get summaryPlaceholder =>
      'Write your professional summary here in detail...';

  @override
  String get saveSummary => 'Save Summary';

  @override
  String get addSkillsInstruction => 'Add your skills one by one:';

  @override
  String get skillsPlaceholder => 'e.g., Flutter, UI Design...';

  @override
  String get finishedAddingSkills => 'Finished adding skills';

  @override
  String get doneWithSkills => 'Done with skills';

  @override
  String get selectLanguageLevel =>
      'Select proficiency level for the language:';

  @override
  String get beginner => 'Beginner';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get advanced => 'Advanced';

  @override
  String get native => 'Native';

  @override
  String get reviewData => 'Review Your Data';

  @override
  String get basicInfo => 'Basic Information';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get emailLabel => 'Email';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get cityLabel => 'City';

  @override
  String get countryLabel => 'Country';

  @override
  String get targetCountryLabel => 'Target Country';

  @override
  String get jobTitleLabel => 'Job Title';

  @override
  String get summaryLabel => 'Summary';

  @override
  String get experienceSection => 'Work Experience';

  @override
  String get educationSection => 'Education';

  @override
  String get skillsSection => 'Skills';

  @override
  String get languagesSection => 'Languages';

  @override
  String get projectsSection => 'Projects / Portfolio';

  @override
  String get additionalInfoSection => 'Additional Information';

  @override
  String get additionalInfoPlaceholder => 'Any other information';

  @override
  String get addExperience => 'Add Experience';

  @override
  String get addWorkExperience => 'Add Work Experience';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get editExperience => 'Edit Experience';

  @override
  String get jobTitleField => 'Job Title';

  @override
  String get companyField => 'Company';

  @override
  String get locationField => 'Location';

  @override
  String get durationField => 'Duration (e.g., 2020 - 2022)';

  @override
  String get responsibilitiesField => 'Responsibilities (separate with -)';

  @override
  String get portfolioLinksField => 'Portfolio links (separate with space)';

  @override
  String get portfolioLabel => 'Portfolio / Links:';

  @override
  String get addEducation => 'Add Education';

  @override
  String get degreeField => 'Degree';

  @override
  String get institutionField => 'Institution';

  @override
  String get periodField => 'Period';

  @override
  String get addSkill => 'Add Skill';

  @override
  String get addLanguage => 'Add Language';

  @override
  String get languageField => 'Language';

  @override
  String get levelField => 'Level';

  @override
  String get addProject => 'Add Project';

  @override
  String get addProjectLink => 'Add Project / Link';

  @override
  String get titleField => 'Title';

  @override
  String get linkField => 'Link';

  @override
  String get chooseCVMethod => 'Choose Your CV Builder';

  @override
  String get aiChatMode => 'AI Chat Assistant';

  @override
  String get aiChatDescription =>
      'Let our AI guide you through building your CV with simple conversation';

  @override
  String get manualMode => 'Manual Form';

  @override
  String get manualDescription =>
      'Build your CV yourself with full control over every detail';

  @override
  String get getStarted => 'Get Started';

  @override
  String get noSavedCVs => 'No saved CVs yet';

  @override
  String get searchPlaceholder => 'Search your CVs...';

  @override
  String get view => 'VIEW';

  @override
  String get pdf => 'PDF';

  @override
  String get unknownDate => 'Unknown Date';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get premiumPlan => 'Premium Plan';

  @override
  String get active => 'ACTIVE';

  @override
  String get notifications => 'Notifications';

  @override
  String get version => 'Version';

  @override
  String get linkedinLabel => 'LinkedIn Profile';

  @override
  String get githubLabel => 'GitHub Profile';

  @override
  String get customSections => 'Custom Sections';

  @override
  String get addCustomSection => 'Add Custom Section';

  @override
  String get sectionTitle => 'Section Title';

  @override
  String get sectionContent => 'Section Content';

  @override
  String get reorderSections => 'Reorder Sections';

  @override
  String get projectRole => 'Role (e.g., Team Lead)';

  @override
  String get projectDescription => 'Project Description';

  @override
  String get noResultsFound => 'No results found!';

  @override
  String get editProject => 'Edit Project';

  @override
  String get invalidName => 'Invalid name, please enter a real name.';

  @override
  String get invalidEmail => 'Invalid email address.';

  @override
  String get invalidPhone => 'Invalid phone number.';

  @override
  String get invalidUrl => 'Invalid link.';

  @override
  String get fieldRequired => 'Value cannot be empty.';
}
