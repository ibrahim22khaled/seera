import 'dart:async';
import 'package:seera/core/services/voice_service.dart';

class VoiceHandler {
  final VoiceService _voiceService;
  VoiceHandler(this._voiceService);

  bool get isListening => _voiceService.isListening;

  Future<bool> startListening(Function(String) onResult, String locale) async {
    return await _voiceService.startListening(onResult, localeId: locale);
  }

  Future<void> stopListening() async {
    await _voiceService.stopListening();
  }
}
