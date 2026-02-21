import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:seera/core/services/ai_service.dart';
import 'package:seera/core/services/mock_gemini_service.dart';
import 'core/theme/app_theme.dart';
import 'features/chat/presentation/cubit/chat_cubit.dart';
import 'features/onboarding/presentation/pages/onboarding_screen.dart';
import 'features/splash/presentation/pages/splash_screen.dart';
import 'features/navigation/presentation/pages/main_scaffold.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/register_screen.dart';
import 'features/auth/presentation/pages/forgot_password_screen.dart';
import 'features/auth/presentation/pages/email_verification_screen.dart';
import 'features/cv_builder/presentation/pages/download_screen.dart';
import 'features/cv_builder/presentation/cubit/cv_builder_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:seera/generated/l10n/app_localizations.dart';
import 'core/services/locale_cubit.dart';
import 'core/theme/theme_cubit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:seera/core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Choose the service based on configuration
    final ChatService aiService;
    final List<ChatService> availableServices = [];

    final bool useMockMode = dotenv.env['USE_MOCK_MODE'] == 'true';
    final String groqApiKey = dotenv.env['GROQ_API_KEY'] ?? '';
    final String openRouterApiKey = dotenv.env['OPEN_ROUTER_API_KEY'] ?? '';
    final String huggingFaceApiKey = dotenv.env['HUGGING_FACE_API_KEY'] ?? '';
    final String geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    if (useMockMode) {
      availableServices.add(MockGeminiService());
    } else {
      if (groqApiKey.isNotEmpty) {
        availableServices.add(
          GroqService(
            apiKey: groqApiKey,
            systemPrompt: AppConstants.systemPrompt,
          ),
        );
      }
      if (openRouterApiKey.isNotEmpty) {
        availableServices.add(
          OpenRouterService(
            apiKey: openRouterApiKey,
            systemPrompt: AppConstants.systemPrompt,
          ),
        );
      }
      if (huggingFaceApiKey.isNotEmpty) {
        availableServices.add(
          HuggingFaceService(
            apiKey: huggingFaceApiKey,
            systemPrompt: AppConstants.systemPrompt,
          ),
        );
      }
      if (geminiApiKey.isNotEmpty) {
        // availableServices.add(
        //   GeminiService(apiKey: geminiApiKey, systemPrompt: _systemPrompt),
        // );
      }
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
        BlocProvider(create: (context) => CVBuilderCubit()),
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                title: 'Seera',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: ThemeMode.dark, // Forced Dark Mode
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
                  '/register': (context) => const RegisterScreen(),
                  '/forgot-password': (context) => const ForgotPasswordScreen(),
                  '/verify-email': (context) => const EmailVerificationScreen(),
                  '/chat': (context) => const MainScaffold(),
                  '/download': (context) => const DownloadScreen(),
                },
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}
