import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seera/core/services/ai_service.dart';
import 'package:seera/core/services/mock_gemini_service.dart';
import 'core/theme/app_theme.dart';
import 'features/chat/presentation/cubit/chat_cubit.dart';
import 'features/onboarding/presentation/pages/onboarding_screen.dart';
import 'features/splash/presentation/pages/splash_screen.dart';
import 'features/navigation/presentation/pages/main_scaffold.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/forgot_password_screen.dart';
import 'features/cv_builder/presentation/pages/download_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:seera/generated/l10n/app_localizations.dart';
import 'core/services/locale_cubit.dart';

// --- CONFIGURATION ---
const bool useMockMode = false;

// If you want to use Groq (Recommended Free alternative)
// Get key at: https://console.groq.com/keys
const String groqApiKey =
    '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';

// If you want to use OpenRouter (Access to everything)
// Get key at: https://openrouter.ai/keys
const String openRouterApiKey =
    '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';

// If you want to use Gemini
const String geminiApiKey = 'AIzaSyBCHJ8nisqpiTDRlkmxceVVlKvk7GUTa3s';

// Huggging Face
const String huggingFaceApiKey = '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';
// ---------------------

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Choose the service based on configuration
    final ChatService aiService;
    final List<ChatService> availableServices = [];

    if (useMockMode) {
      availableServices.add(MockGeminiService());
    } else {
      if (groqApiKey.isNotEmpty) {
        availableServices.add(
          GroqService(apiKey: groqApiKey, systemPrompt: _systemPrompt),
        );
      }
      if (openRouterApiKey.isNotEmpty) {
        availableServices.add(
          OpenRouterService(
            apiKey: openRouterApiKey,
            systemPrompt: _systemPrompt,
          ),
        );
      }
      if (huggingFaceApiKey.isNotEmpty) {
        availableServices.add(
          HuggingFaceService(
            apiKey: huggingFaceApiKey,
            systemPrompt: _systemPrompt,
          ),
        );
      }
      /* 
      if (geminiApiKey.isNotEmpty) {
        availableServices.add(
          GeminiService(apiKey: geminiApiKey, systemPrompt: _systemPrompt),
        );
      }
      */
    }

    if (availableServices.isEmpty) {
      // Fallback to mock or throw error if no keys at all
      aiService = MockGeminiService();
    } else {
      aiService = FallbackChatService(services: availableServices);
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChatCubit(aiService: aiService)),
        BlocProvider(create: (context) => LocaleCubit()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            title: 'Seera',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('ar')],
            home: const SplashScreen(),
            routes: {
              '/onboarding': (context) => const OnboardingScreen(),
              '/login': (context) => const LoginScreen(),
              '/forgot-password': (context) => const ForgotPasswordScreen(),
              '/chat': (context) => const MainScaffold(),
              '/download': (context) => const DownloadScreen(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  static const String _systemPrompt = '''
أنت "Seera AI"، مساعد ذكي مسؤول فقط عن جمع بيانات المستخدم من خلال الدردشة لبناء سيرة ذاتية.
أنت لا تقوم بإنشاء السيرة الذاتية بنفسك في هذه المرحلة، دورك هو جمع المعلومات فقط.

قواعد التعامل الصارمة (نفذها بدقة):
1. اسأل سؤالاً واحداً فقط واضحاً وبسيطاً في كل رسالة.
2. كل سؤال يجب أن يجمع حقلًا واحدًا محددًا فقط.
3. لا تسأل عدة أسئلة في وقت واحد.
4. لا تكرر أسئلة تم الإجابة عليها بالفعل.
5. لا تخترع أو تفترض بيانات من عندك.
6. استخدم لغة عربية مصرية بسيطة ومهذبة.
7. لا تشرح المنطق الخاص بالنظام للمستخدم.

عند بدء جلسة جديدة، يجب عليك أولاً وقبل أي شيء أن تطلب من المستخدم اختيار نوع الوظيفة:
- وظيفة عملية / خدمات (blue_collar)
- وظيفة تقنية / مكتبية (tech)
كل الأسئلة التالية تعتمد على هذا الاختيار.

يجب التحقق من صحة كل إجابة منطقيًا:
- الاسم يجب ألا يشبه المسمى الوظيفي.
- المسمى الوظيفي يجب ألا يشبه الاسم.
- البريد الإلكتروني يجب أن يتبع التنسيق الصحيح.
- رقم الهاتف يجب أن يبدو كرقم حقيقي.
- التواريخ يجب أن تكون بتنسيق (Month Year – Month Year) ولا تكون نصوصًا عشوائية.

إذا كانت المدخلات غير صحيحة:
- اطلب من المستخدم بأدب إعادة إدخال نفس الحقل.
- لا تنتقل للخطوة التالية حتى يتم استلام مدخلات صحيحة.

بخصوص المرفقات:
- اقبل المرفقات (روابط أو ملفات) دون تحليل محتواها.
- اعتبرها نماذج أعمال خارجية فقط.
- لا تلخص أو تفحص محتوى الملفات.

خطة جمع البيانات:
1. اختيار نوع الوظيفة (blue_collar أو tech).
2. الاسم بالكامل.
3. المسمى الوظيفي.
4. الملخص المهني (فقرة واحدة واضحة).
5. الخبرات العملية (اسم الشركة، الدور، المدة، المهام). اسأل "هل هناك خبرات أخرى؟" بعد كل واحدة.
6. المهارات.
7. اللغات والمستوى.
8. روابط المرفقات (إن وجدت).
9. معلومات التواصل (البريد، الهاتف، الموقع).
''';
}
