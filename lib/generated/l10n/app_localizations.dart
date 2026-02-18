import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Seera'**
  String get appTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to generate your ATS-friendly CV'**
  String get loginSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @chatToBuildCV.
  ///
  /// In en, this message translates to:
  /// **'Chat to build your CV'**
  String get chatToBuildCV;

  /// No description provided for @chatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Answer simple questions and our AI will craft a professional, ATS-friendly resume for you in minutes.'**
  String get chatSubtitle;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @previewPdf.
  ///
  /// In en, this message translates to:
  /// **'PREVIEW PDF'**
  String get previewPdf;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'ONLINE'**
  String get online;

  /// No description provided for @typeYourResponse.
  ///
  /// In en, this message translates to:
  /// **'Type your response...'**
  String get typeYourResponse;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @resumes.
  ///
  /// In en, this message translates to:
  /// **'Resumes'**
  String get resumes;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @enterEmailToReset.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a password reset link. We\'ll help you get back into your account.'**
  String get enterEmailToReset;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get enterEmail;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email'**
  String get resetLinkSent;

  /// No description provided for @resetFailed.
  ///
  /// In en, this message translates to:
  /// **'Reset failed'**
  String get resetFailed;

  /// No description provided for @rememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get rememberPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @welcomeToSeera.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Seera, {name}!'**
  String welcomeToSeera(Object name);

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @joinSeera.
  ///
  /// In en, this message translates to:
  /// **'Join Seera'**
  String get joinSeera;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @langSettings.
  ///
  /// In en, this message translates to:
  /// **'Language settings'**
  String get langSettings;

  /// No description provided for @primaryLanguage.
  ///
  /// In en, this message translates to:
  /// **'Primary Language'**
  String get primaryLanguage;

  /// No description provided for @preferredAiDialect.
  ///
  /// In en, this message translates to:
  /// **'Preferred AI Dialect'**
  String get preferredAiDialect;

  /// No description provided for @toneSetting.
  ///
  /// In en, this message translates to:
  /// **'TONE SETTING'**
  String get toneSetting;

  /// No description provided for @slangEnglish.
  ///
  /// In en, this message translates to:
  /// **'Slang English'**
  String get slangEnglish;

  /// No description provided for @egyptianArabic.
  ///
  /// In en, this message translates to:
  /// **'Egyptian Arabic'**
  String get egyptianArabic;

  /// No description provided for @saudiArabic.
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabic'**
  String get saudiArabic;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleaseFillAllFields;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login Successful'**
  String get loginSuccessful;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In failed: {error}'**
  String googleSignInFailed(Object error);

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @internalError.
  ///
  /// In en, this message translates to:
  /// **'An internal error occurred. Please try again later.'**
  String get internalError;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get networkError;

  /// No description provided for @cvCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'CV created successfully!'**
  String get cvCreatedSuccess;

  /// No description provided for @printingError.
  ///
  /// In en, this message translates to:
  /// **'Error printing CV: {error}'**
  String printingError(Object error);

  /// No description provided for @micPermissionError.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is required. Please enable it in settings.'**
  String get micPermissionError;

  /// No description provided for @micInitError.
  ///
  /// In en, this message translates to:
  /// **'Could not initialize microphone. Please restart the app.'**
  String get micInitError;

  /// No description provided for @micGenericError.
  ///
  /// In en, this message translates to:
  /// **'Microphone error: {error}'**
  String micGenericError(Object error);

  /// No description provided for @micNotWorking.
  ///
  /// In en, this message translates to:
  /// **'Microphone is not working, please check permissions or type instead.'**
  String get micNotWorking;

  /// No description provided for @galleryImageAttached.
  ///
  /// In en, this message translates to:
  /// **'Image from gallery: {name}'**
  String galleryImageAttached(Object name);

  /// No description provided for @imageSavedAI.
  ///
  /// In en, this message translates to:
  /// **'Image saved as work sample. Anything else to add?'**
  String get imageSavedAI;

  /// No description provided for @fileOpenError.
  ///
  /// In en, this message translates to:
  /// **'Could not open files. If you just added this feature, a full restart is required.'**
  String get fileOpenError;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error: {error}'**
  String connectionError(Object error);

  /// No description provided for @dataCollectionError.
  ///
  /// In en, this message translates to:
  /// **'Error collecting your data: {error}'**
  String dataCollectionError(Object error);

  /// No description provided for @missingBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'We still need basic info (Name, Email, Phone, Job Title) to generate the CV.'**
  String get missingBasicInfo;

  /// No description provided for @cvReady.
  ///
  /// In en, this message translates to:
  /// **'CV is ready! Good luck.'**
  String get cvReady;

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get newChat;

  /// No description provided for @startNewChat.
  ///
  /// In en, this message translates to:
  /// **'Start New Chat'**
  String get startNewChat;

  /// No description provided for @deleteConversation.
  ///
  /// In en, this message translates to:
  /// **'Delete Conversation?'**
  String get deleteConversation;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this conversation? This action cannot be undone.'**
  String get deleteConfirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @signedOut.
  ///
  /// In en, this message translates to:
  /// **'You signed out'**
  String get signedOut;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get today;

  /// No description provided for @startChatting.
  ///
  /// In en, this message translates to:
  /// **'Start chatting to build your CV!'**
  String get startChatting;

  /// No description provided for @summaryPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Write your professional summary here in detail...'**
  String get summaryPlaceholder;

  /// No description provided for @saveSummary.
  ///
  /// In en, this message translates to:
  /// **'Save Summary'**
  String get saveSummary;

  /// No description provided for @addSkillsInstruction.
  ///
  /// In en, this message translates to:
  /// **'Add your skills one by one:'**
  String get addSkillsInstruction;

  /// No description provided for @skillsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Flutter, UI Design...'**
  String get skillsPlaceholder;

  /// No description provided for @finishedAddingSkills.
  ///
  /// In en, this message translates to:
  /// **'Finished adding skills'**
  String get finishedAddingSkills;

  /// No description provided for @doneWithSkills.
  ///
  /// In en, this message translates to:
  /// **'Done with skills'**
  String get doneWithSkills;

  /// No description provided for @selectLanguageLevel.
  ///
  /// In en, this message translates to:
  /// **'Select proficiency level for the language:'**
  String get selectLanguageLevel;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @native.
  ///
  /// In en, this message translates to:
  /// **'Native'**
  String get native;

  /// No description provided for @reviewData.
  ///
  /// In en, this message translates to:
  /// **'Review Your Data'**
  String get reviewData;

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInfo;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneLabel;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// No description provided for @targetCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Target Country'**
  String get targetCountryLabel;

  /// No description provided for @jobTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitleLabel;

  /// No description provided for @summaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summaryLabel;

  /// No description provided for @experienceSection.
  ///
  /// In en, this message translates to:
  /// **'Work Experience'**
  String get experienceSection;

  /// No description provided for @educationSection.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get educationSection;

  /// No description provided for @skillsSection.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skillsSection;

  /// No description provided for @languagesSection.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languagesSection;

  /// No description provided for @projectsSection.
  ///
  /// In en, this message translates to:
  /// **'Projects / Portfolio'**
  String get projectsSection;

  /// No description provided for @additionalInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInfoSection;

  /// No description provided for @additionalInfoPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Any other information'**
  String get additionalInfoPlaceholder;

  /// No description provided for @addExperience.
  ///
  /// In en, this message translates to:
  /// **'Add Experience'**
  String get addExperience;

  /// No description provided for @addWorkExperience.
  ///
  /// In en, this message translates to:
  /// **'Add Work Experience'**
  String get addWorkExperience;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editExperience.
  ///
  /// In en, this message translates to:
  /// **'Edit Experience'**
  String get editExperience;

  /// No description provided for @jobTitleField.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitleField;

  /// No description provided for @companyField.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get companyField;

  /// No description provided for @locationField.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationField;

  /// No description provided for @durationField.
  ///
  /// In en, this message translates to:
  /// **'Duration (e.g., 2020 - 2022)'**
  String get durationField;

  /// No description provided for @responsibilitiesField.
  ///
  /// In en, this message translates to:
  /// **'Responsibilities (separate with -)'**
  String get responsibilitiesField;

  /// No description provided for @portfolioLinksField.
  ///
  /// In en, this message translates to:
  /// **'Portfolio links (separate with space)'**
  String get portfolioLinksField;

  /// No description provided for @portfolioLabel.
  ///
  /// In en, this message translates to:
  /// **'Portfolio / Links:'**
  String get portfolioLabel;

  /// No description provided for @addEducation.
  ///
  /// In en, this message translates to:
  /// **'Add Education'**
  String get addEducation;

  /// No description provided for @degreeField.
  ///
  /// In en, this message translates to:
  /// **'Degree'**
  String get degreeField;

  /// No description provided for @institutionField.
  ///
  /// In en, this message translates to:
  /// **'Institution'**
  String get institutionField;

  /// No description provided for @periodField.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get periodField;

  /// No description provided for @addSkill.
  ///
  /// In en, this message translates to:
  /// **'Add Skill'**
  String get addSkill;

  /// No description provided for @addLanguage.
  ///
  /// In en, this message translates to:
  /// **'Add Language'**
  String get addLanguage;

  /// No description provided for @languageField.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageField;

  /// No description provided for @levelField.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get levelField;

  /// No description provided for @addProject.
  ///
  /// In en, this message translates to:
  /// **'Add Project'**
  String get addProject;

  /// No description provided for @addProjectLink.
  ///
  /// In en, this message translates to:
  /// **'Add Project / Link'**
  String get addProjectLink;

  /// No description provided for @titleField.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleField;

  /// No description provided for @linkField.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get linkField;

  /// No description provided for @chooseCVMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose Your CV Builder'**
  String get chooseCVMethod;

  /// No description provided for @aiChatMode.
  ///
  /// In en, this message translates to:
  /// **'AI Chat Assistant'**
  String get aiChatMode;

  /// No description provided for @aiChatDescription.
  ///
  /// In en, this message translates to:
  /// **'Let our AI guide you through building your CV with simple conversation'**
  String get aiChatDescription;

  /// No description provided for @manualMode.
  ///
  /// In en, this message translates to:
  /// **'Manual Form'**
  String get manualMode;

  /// No description provided for @manualDescription.
  ///
  /// In en, this message translates to:
  /// **'Build your CV yourself with full control over every detail'**
  String get manualDescription;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @noSavedCVs.
  ///
  /// In en, this message translates to:
  /// **'No saved CVs yet'**
  String get noSavedCVs;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search your CVs...'**
  String get searchPlaceholder;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'VIEW'**
  String get view;

  /// No description provided for @pdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @unknownDate.
  ///
  /// In en, this message translates to:
  /// **'Unknown Date'**
  String get unknownDate;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @premiumPlan.
  ///
  /// In en, this message translates to:
  /// **'Premium Plan'**
  String get premiumPlan;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get active;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @linkedinLabel.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn Profile'**
  String get linkedinLabel;

  /// No description provided for @githubLabel.
  ///
  /// In en, this message translates to:
  /// **'GitHub Profile'**
  String get githubLabel;

  /// No description provided for @customSections.
  ///
  /// In en, this message translates to:
  /// **'Custom Sections'**
  String get customSections;

  /// No description provided for @addCustomSection.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Section'**
  String get addCustomSection;

  /// No description provided for @sectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Section Title'**
  String get sectionTitle;

  /// No description provided for @sectionContent.
  ///
  /// In en, this message translates to:
  /// **'Section Content'**
  String get sectionContent;

  /// No description provided for @reorderSections.
  ///
  /// In en, this message translates to:
  /// **'Reorder Sections'**
  String get reorderSections;

  /// No description provided for @projectRole.
  ///
  /// In en, this message translates to:
  /// **'Role (e.g., Team Lead)'**
  String get projectRole;

  /// No description provided for @projectDescription.
  ///
  /// In en, this message translates to:
  /// **'Project Description'**
  String get projectDescription;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found!'**
  String get noResultsFound;

  /// No description provided for @editProject.
  ///
  /// In en, this message translates to:
  /// **'Edit Project'**
  String get editProject;

  /// No description provided for @invalidName.
  ///
  /// In en, this message translates to:
  /// **'Invalid name, please enter a real name.'**
  String get invalidName;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address.'**
  String get invalidEmail;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number.'**
  String get invalidPhone;

  /// No description provided for @invalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Invalid link.'**
  String get invalidUrl;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Value cannot be empty.'**
  String get fieldRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get passwordTooShort;

  /// No description provided for @verifyEmailFirst.
  ///
  /// In en, this message translates to:
  /// **'Please verify your email first.'**
  String get verifyEmailFirst;

  /// No description provided for @emailVerificationSent.
  ///
  /// In en, this message translates to:
  /// **'Verification link sent to your email.'**
  String get emailVerificationSent;

  /// No description provided for @invalidNameNoNumbers.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid name without numbers.'**
  String get invalidNameNoNumbers;

  /// No description provided for @passwordWeak.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak.'**
  String get passwordWeak;

  /// No description provided for @verifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verifyEmail;

  /// No description provided for @emailVerificationInstructions.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification link to:\n{email}\n\nPlease follow these steps:\n1) Open your email.\n2) Click on the verification link.\n3) Come back to the app and click the button below.'**
  String emailVerificationInstructions(String email);

  /// No description provided for @checkVerificationStatus.
  ///
  /// In en, this message translates to:
  /// **'Check Status / Refresh'**
  String get checkVerificationStatus;

  /// No description provided for @resendLink.
  ///
  /// In en, this message translates to:
  /// **'Resend Link'**
  String get resendLink;

  /// No description provided for @emailNotVerifiedYet.
  ///
  /// In en, this message translates to:
  /// **'Your email is still not verified. Please check your inbox.'**
  String get emailNotVerifiedYet;

  /// No description provided for @emailVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Email verified successfully!'**
  String get emailVerifiedSuccess;

  /// No description provided for @aiLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You have reached the AI limit. Please try again later.'**
  String get aiLimitReached;

  /// No description provided for @clearDataConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all data? This cannot be undone.'**
  String get clearDataConfirmation;

  /// No description provided for @clearData.
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get clearData;

  /// No description provided for @pleaseLoginToPrint.
  ///
  /// In en, this message translates to:
  /// **'Please login first to print or download your CV.'**
  String get pleaseLoginToPrint;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
