import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seera/core/services/ai_service.dart';
import 'package:seera/core/services/voice_service.dart';
import 'package:seera/features/cv_builder/data/models/cv_model.dart';
import 'package:seera/features/cv_builder/domain/services/pdf_service.dart';
import 'package:seera/generated/l10n/app_localizations.dart';

import '../../domain/handlers/session_handler.dart';
import '../../domain/handlers/voice_handler.dart';
import '../../domain/handlers/field_handler.dart';
import '../../domain/handlers/cv_handler.dart';
import '../../data/models/chat_session.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatService _aiService;
  final SessionHandler _sessionHandler;
  final VoiceHandler _voiceHandler;
  final FieldHandler _fieldHandler;
  final CvHandler _cvHandler;

  // We need a way to access localization, but Cubit doesn't have context.
  // We can pass the L10n object to methods or use a rigorous approach.
  // For simplicity in this refactor, we will accept AppLocalizations in methods
  // or use a callback if strictly necessary.
  // However, simpler is: passing AppLocalizations to the method calls from UI.

  ChatCubit({
    required ChatService aiService,
    VoiceService? voiceService,
    PdfService? pdfService,
  }) : _aiService = aiService,
       _sessionHandler = SessionHandler(),
       _voiceHandler = VoiceHandler(voiceService ?? VoiceServiceImpl()),
       _fieldHandler = FieldHandler(),
       _cvHandler = CvHandler(aiService, pdfService: pdfService),
       super(ChatInitial()) {
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    await _sessionHandler.load(prefs);

    if (_sessionHandler.sessions.isEmpty) {
      // Create default session
      await createNewSession();
    } else {
      _emitLoaded();
      _detectField();
    }
  }

  Future<void> createNewSession() async {
    final prefs = await SharedPreferences.getInstance();
    final newSession = ChatSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title:
          '__new_chat__', // Placeholder, should be replaced with localized string in UI
      messages: [],
    );
    _sessionHandler.sessions.insert(0, newSession);
    _sessionHandler.currentSessionId = newSession.id;
    await _sessionHandler.save(prefs);
    _emitLoaded();
    _fieldHandler.currentField = 'name';
  }

  Future<void> switchSession(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    _sessionHandler.currentSessionId = sessionId;
    await _sessionHandler.save(prefs);
    _emitLoaded();
    _detectField();
  }

  Future<void> deleteSession(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    _sessionHandler.sessions.removeWhere((s) => s.id == sessionId);
    if (_sessionHandler.sessions.isEmpty) {
      await createNewSession();
    } else {
      if (_sessionHandler.currentSessionId == sessionId) {
        _sessionHandler.currentSessionId = _sessionHandler.sessions.first.id;
      }
      await _sessionHandler.save(prefs);
      await switchSession(_sessionHandler.currentSessionId);
    }
  }

  void _detectField() {
    final currentSession = _sessionHandler.currentSession;
    if (currentSession.messages.isEmpty) {
      _fieldHandler.currentField = 'name';
      return;
    }
    final lastAiMessage = currentSession.messages.lastWhere(
      (m) => m.startsWith('AI:'),
      orElse: () => '',
    );

    _fieldHandler.detectField(lastAiMessage);
  }

  void _emitLoaded({bool isListening = false}) {
    emit(
      ChatLoaded(
        List<String>.from(_sessionHandler.currentSession.messages),
        isListening: isListening,
        sessions: List<ChatSession>.from(_sessionHandler.sessions),
        currentSessionId: _sessionHandler.currentSessionId,
        currentField: _fieldHandler.currentField,
      ),
    );
  }

  Future<void> sendMessage(String message, AppLocalizations l10n) async {
    final currentSession = _sessionHandler.currentSession;
    final prefs = await SharedPreferences.getInstance();

    // Field Validation
    // We validate against the *current* field we are expecting.
    final fieldToValidate = _fieldHandler.currentField ?? 'unknown';
    final error = _fieldHandler.validate(fieldToValidate, message, l10n);
    if (error != null) {
      currentSession.messages.add('You: $message');
      currentSession.messages.add('AI: $error');
      await _sessionHandler.save(prefs);
      _emitLoaded();
      return;
    }

    currentSession.messages.add('You: $message');
    // Update title logic
    if (currentSession.messages.length == 1 ||
        currentSession.title == '__new_chat__') {
      // Find session index
      final index = _sessionHandler.sessions.indexOf(currentSession);
      if (index != -1) {
        _sessionHandler.sessions[index] = ChatSession(
          id: currentSession.id,
          title: message.length > 30
              ? '${message.substring(0, 30)}...'
              : message,
          messages: currentSession.messages,
        );
      }
    }

    await _sessionHandler.save(prefs);
    _emitLoaded();

    try {
      final aiResponse = await _aiService.sendMessage(
        message,
        List<String>.from(currentSession.messages),
      );
      currentSession.messages.add('AI: $aiResponse');

      await _sessionHandler.save(prefs);
      _detectField();
      _emitLoaded();
    } catch (e) {
      emit(
        ChatError(
          l10n.connectionError(e.toString()),
          List<String>.from(currentSession.messages),
          sessions: List<ChatSession>.from(_sessionHandler.sessions),
          currentSessionId: _sessionHandler.currentSessionId,
          currentField: _fieldHandler.currentField,
        ),
      );
    }
  }

  Future<void> pickImage(AppLocalizations l10n) async {
    final currentSession = _sessionHandler.currentSession;
    final prefs = await SharedPreferences.getInstance();

    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final attachmentUrl = l10n.galleryImageAttached(image.name);
        currentSession.messages.add('You: [Attached Image] $attachmentUrl');
        await _sessionHandler.save(prefs);
        _emitLoaded();

        currentSession.messages.add('AI: ${l10n.imageSavedAI}');
        await _sessionHandler.save(prefs);
        _emitLoaded();
      }
    } catch (e) {
      emit(
        ChatError(
          l10n.fileOpenError,
          List<String>.from(currentSession.messages),
          sessions: List<ChatSession>.from(_sessionHandler.sessions),
          currentSessionId: _sessionHandler.currentSessionId,
          currentField: _fieldHandler.currentField,
        ),
      );
    }
  }

  Future<void> toggleListening(AppLocalizations l10n, String localeId) async {
    final currentSession = _sessionHandler.currentSession;

    if (_voiceHandler.isListening) {
      await _voiceHandler.stopListening();
      _emitLoaded(isListening: false);
      return;
    }

    try {
      final available = await _voiceHandler.startListening((text) {
        if (text.isNotEmpty) {
          _voiceHandler.stopListening();
          sendMessage(text, l10n);
        }
      }, localeId); // Passing localeId correctly

      if (available) {
        _emitLoaded(isListening: true);
      } else {
        emit(
          ChatError(
            l10n.micNotWorking,
            List<String>.from(currentSession.messages),
            sessions: List<ChatSession>.from(_sessionHandler.sessions),
            currentSessionId: _sessionHandler.currentSessionId,
            currentField: _fieldHandler.currentField,
          ),
        );
      }
    } catch (e) {
      String errorMessage = l10n.micGenericError(e.toString());
      if (e.toString().contains('permission')) {
        errorMessage = l10n.micPermissionError;
      } else if (e.toString().contains('initialize')) {
        errorMessage = l10n.micInitError;
      }

      emit(
        ChatError(
          errorMessage,
          List<String>.from(currentSession.messages),
          sessions: List<ChatSession>.from(_sessionHandler.sessions),
          currentSessionId: _sessionHandler.currentSessionId,
          currentField: _fieldHandler.currentField,
        ),
      );
    }
  }

  Future<void> generateCV(AppLocalizations l10n) async {
    final currentSession = _sessionHandler.currentSession;

    if (!_cvHandler.canGenerate(currentSession.messages)) {
      emit(
        ChatError(
          l10n.missingBasicInfo,
          List<String>.from(currentSession.messages),
          sessions: List<ChatSession>.from(_sessionHandler.sessions),
          currentSessionId: _sessionHandler.currentSessionId,
          currentField: _fieldHandler.currentField,
        ),
      );
      return;
    }

    emit(
      ChatLoading(
        sessions: List<ChatSession>.from(_sessionHandler.sessions),
        currentSessionId: _sessionHandler.currentSessionId,
        currentField: _fieldHandler.currentField,
      ),
    );

    try {
      final cvModel = await _cvHandler.generateCV(currentSession.messages);

      emit(
        ChatReview(
          List<String>.from(currentSession.messages),
          cvModel,
          sessions: List<ChatSession>.from(_sessionHandler.sessions),
          currentSessionId: _sessionHandler.currentSessionId,
          currentField: _fieldHandler.currentField,
        ),
      );
    } catch (e) {
      emit(
        ChatError(
          l10n.dataCollectionError(e.toString()),
          List<String>.from(currentSession.messages),
          sessions: List<ChatSession>.from(_sessionHandler.sessions),
          currentSessionId: _sessionHandler.currentSessionId,
          currentField: _fieldHandler.currentField,
        ),
      );
    }
  }

  Future<void> finalizePdf(CVModel validatedData, AppLocalizations l10n) async {
    final currentSession = _sessionHandler.currentSession;
    final prefs = await SharedPreferences.getInstance();

    emit(
      ChatLoading(
        sessions: List<ChatSession>.from(_sessionHandler.sessions),
        currentSessionId: _sessionHandler.currentSessionId,
        currentField: _fieldHandler.currentField,
      ),
    );

    try {
      await _cvHandler.generateAndPrintPdf(validatedData, l10n);

      currentSession.messages.add('AI: ${l10n.cvReady}');
      await _sessionHandler.save(prefs);

      _emitLoaded();
    } catch (e) {
      emit(
        ChatError(
          l10n.printingError(e.toString()),
          List<String>.from(currentSession.messages),
          sessions: List<ChatSession>.from(_sessionHandler.sessions),
          currentSessionId: _sessionHandler.currentSessionId,
          currentField: _fieldHandler.currentField,
        ),
      );
    }
  }
}
