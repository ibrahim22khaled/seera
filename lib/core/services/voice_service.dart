import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

abstract class VoiceService {
  Future<void> speak(String text);
  Future<void> stopSpeaking();
  Future<bool> startListening(Function(String) onResult, {String? localeId});
  Future<void> stopListening();
  Future<void> setLocale(String localeId);
  bool get isListening;
}

class VoiceServiceImpl implements VoiceService {
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  VoiceServiceImpl() {
    _initTts();
  }

  void _initTts() async {
    try {
      await _flutterTts.setLanguage("ar-EG"); // Egyptian Arabic
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5); // Slower for clarity
      debugPrint('TTS initialized successfully');
    } catch (e) {
      debugPrint('TTS initialization error: $e');
    }
  }

  @override
  Future<void> setLocale(String localeId) async {
    try {
      await _flutterTts.setLanguage(localeId);
      debugPrint('TTS locale set to: $localeId');
    } catch (e) {
      debugPrint('Error setting TTS locale: $e');
    }
  }

  @override
  Future<void> speak(String text) async {
    try {
      if (text.isNotEmpty) {
        await _flutterTts.speak(text);
      }
    } catch (e) {
      debugPrint('TTS speak error: $e');
    }
  }

  @override
  Future<void> stopSpeaking() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      debugPrint('TTS stop error: $e');
    }
  }

  @override
  Future<bool> startListening(
    Function(String) onResult, {
    String? localeId,
  }) async {
    try {
      debugPrint('Requesting microphone permission...');

      // Request microphone permission
      var status = await Permission.microphone.request();
      debugPrint('Microphone permission status: $status');

      if (status != PermissionStatus.granted) {
        debugPrint('Mic permission not granted');
        return false;
      }

      // Initialize speech recognition if not already done
      if (!_isInitialized) {
        debugPrint('Initializing speech recognition...');
        _isInitialized = await _speech.initialize(
          onStatus: (status) => debugPrint('STT Status: $status'),
          onError: (error) {
            debugPrint('STT Error: ${error.errorMsg}');
            debugPrint('STT Error permanent: ${error.permanent}');
          },
        );
        debugPrint('Speech recognition initialized: $_isInitialized');
      }

      if (!_isInitialized) {
        debugPrint('Speech recognition could not be initialized');
        return false;
      }

      // Get available locales
      var locales = await _speech.locales();
      debugPrint(
        'Available locales: ${locales.map((l) => l.localeId).join(", ")}',
      );

      // Find the best locale
      String targetLocale = localeId ?? 'ar-EG';
      var selectedLocale = locales.firstWhere(
        (l) => l.localeId.toLowerCase() == targetLocale.toLowerCase(),
        orElse: () => locales.firstWhere(
          (l) => l.localeId.startsWith(targetLocale.split('-').first),
          orElse: () => locales.first,
        ),
      );
      debugPrint('Selected locale: ${selectedLocale.localeId}');

      // Start listening
      debugPrint('Starting to listen...');
      await _speech.listen(
        onResult: (result) {
          debugPrint(
            'STT Result - final: ${result.finalResult}, words: ${result.recognizedWords}',
          );
          if (result.finalResult && result.recognizedWords.isNotEmpty) {
            onResult(result.recognizedWords);
          }
        },
        localeId: selectedLocale.localeId,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        listenOptions: stt.SpeechListenOptions(
          partialResults:
              true, // Set to true to keep the engine active/feedback loop
          cancelOnError: true,
          listenMode:
              stt.ListenMode.dictation, // Dictation is better for general chat
        ),
      );

      debugPrint('Listening started successfully');
      return true;
    } catch (e, stackTrace) {
      debugPrint('Error in startListening: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  @override
  Future<void> stopListening() async {
    try {
      debugPrint('Stopping listening...');
      await _speech.stop();
      debugPrint('Listening stopped');
    } catch (e) {
      debugPrint('Error stopping listening: $e');
    }
  }

  @override
  bool get isListening {
    final listening = _speech.isListening;
    debugPrint('Is listening: $listening');
    return listening;
  }
}
