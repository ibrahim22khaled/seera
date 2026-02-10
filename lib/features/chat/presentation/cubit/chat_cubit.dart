import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:printing/printing.dart';
import 'package:seera/core/services/ai_service.dart';
import 'package:seera/core/services/voice_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seera/features/cv_builder/data/models/cv_model.dart';
import 'package:seera/features/cv_builder/domain/services/pdf_service.dart';

import 'package:seera/core/services/validator.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatService _aiService;
  final VoiceService _voiceService;
  final PdfService _pdfService;
  final List<ChatSession> _sessions = [];
  String _currentSessionId = '';
  String? _currentField; // To track what we are validating
  String _selectedLocale = 'ar-EG'; // Default to Egyptian Arabic

  ChatCubit({
    required ChatService aiService,
    VoiceService? voiceService,
    PdfService? pdfService,
  }) : _aiService = aiService,
       _voiceService = voiceService ?? VoiceServiceImpl(),
       _pdfService = pdfService ?? PdfServiceImpl(),
       super(ChatInitial()) {
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = prefs.getStringList('chat_sessions') ?? [];

    if (sessionsJson.isNotEmpty) {
      _sessions.clear();
      for (var jsonStr in sessionsJson) {
        _sessions.add(ChatSession.fromJson(jsonDecode(jsonStr)));
      }
      _currentSessionId =
          prefs.getString('current_session_id') ??
          (_sessions.isNotEmpty ? _sessions.first.id : '');
      _selectedLocale = prefs.getString('selected_locale') ?? 'ar-EG';
    } else {
      // Migrate old history if exists
      final oldHistory = prefs.getStringList('chat_history') ?? [];
      if (oldHistory.isNotEmpty) {
        final session = ChatSession(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Migrated Chat',
          messages: oldHistory,
        );
        _sessions.add(session);
        _currentSessionId = session.id;
        await _saveSessions();
        await prefs.remove('chat_history');
      } else {
        await createNewSession();
        return;
      }
    }

    final currentSession = _sessions.firstWhere(
      (s) => s.id == _currentSessionId,
      orElse: () => _sessions.first,
    );
    _currentSessionId = currentSession.id;

    emit(
      ChatLoaded(
        List.from(currentSession.messages),
        sessions: List.from(_sessions),
        currentSessionId: _currentSessionId,
        currentField: _currentField,
        selectedLocale: _selectedLocale,
      ),
    );
    _detectCurrentField();
  }

  Future<void> _saveSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = _sessions.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList('chat_sessions', sessionsJson);
    await prefs.setString('current_session_id', _currentSessionId);
    await prefs.setString('selected_locale', _selectedLocale);
  }

  Future<void> createNewSession() async {
    final newSession = ChatSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'محادثة جديدة',
      messages: [],
    );
    _sessions.insert(0, newSession);
    _currentSessionId = newSession.id;
    await _saveSessions();
    emit(
      ChatLoaded(
        [],
        sessions: List.from(_sessions),
        currentSessionId: _currentSessionId,
        currentField: _currentField,
        selectedLocale: _selectedLocale,
      ),
    );
    _currentField = 'name';
  }

  Future<void> switchSession(String sessionId) async {
    _currentSessionId = sessionId;
    final session = _sessions.firstWhere((s) => s.id == sessionId);
    emit(
      ChatLoaded(
        List.from(session.messages),
        sessions: List.from(_sessions),
        currentSessionId: _currentSessionId,
        currentField: _currentField,
        selectedLocale: _selectedLocale,
      ),
    );
    await _saveSessions();
    _detectCurrentField();
  }

  Future<void> deleteSession(String sessionId) async {
    _sessions.removeWhere((s) => s.id == sessionId);
    if (_sessions.isEmpty) {
      await createNewSession();
    } else {
      if (_currentSessionId == sessionId) {
        _currentSessionId = _sessions.first.id;
      }
      await _saveSessions();
      await switchSession(_currentSessionId);
    }
  }

  void _detectCurrentField() {
    final currentSession = _sessions.firstWhere(
      (s) => s.id == _currentSessionId,
    );
    if (currentSession.messages.isEmpty) {
      _currentField = 'name';
      return;
    }
    final lastAiMessage = currentSession.messages
        .lastWhere((m) => m.startsWith('AI:'), orElse: () => '')
        .toLowerCase();

    final Map<String, List<String>> fieldKeywords = {
      'jobType': [
        'وظيفة',
        'نوع',
        'tech',
        'blue_collar',
        'blue collar',
        'service',
        'job',
        'type',
      ],
      'name': ['اسم', 'name'],
      'email': ['بريد', 'إيميل', 'email'],
      'phone': ['تليفون', 'موبايل', 'phone', 'mobile', 'رقم'],
      'country': ['دولة', 'بلد', 'country'],
      'city': ['مدينة', 'city'],
      'jobTitle': ['مسمى', 'لقب', 'job', 'title'],
      'company': ['شركة', 'مكان', 'company'],
      'role': ['دور', 'مسؤولي', 'مهام', 'role', 'tasks'],
      'link': ['رابط', 'لينك', 'link', 'url'],
      'duration': ['مدة', 'من', 'إلى', 'تاريخ', 'duration', 'date', 'year'],
      'summary': ['ملخص', 'summary', 'نبذة'],
      'skills': ['مهارات', 'skills', 'خبرات تقنية'],
      'language': ['لغة', 'languages', 'arabic', 'english', 'فرنسي'],
      'education': ['تعليم', 'شهادة', 'جامعة', 'education', 'certificate'],
    };

    String? bestMatch;
    int maxIndex = -1;

    fieldKeywords.forEach((field, keywords) {
      for (var keyword in keywords) {
        final index = lastAiMessage.lastIndexOf(keyword.toLowerCase());
        if (index > maxIndex) {
          maxIndex = index;
          bestMatch = field;
        }
      }
    });

    if (bestMatch != null) {
      _currentField = bestMatch;
    }
  }

  Future<void> sendMessage(String message) async {
    final currentSessionIndex = _sessions.indexWhere(
      (s) => s.id == _currentSessionId,
    );
    if (currentSessionIndex == -1) return;

    final currentMessages = _sessions[currentSessionIndex].messages;

    // Basic validation before sending
    if (_currentField != null) {
      final error = Validator.validateField(_currentField!, message);
      if (error != null) {
        currentMessages.add('You: $message');
        currentMessages.add('AI: $error');
        emit(
          ChatLoaded(
            List.from(currentMessages),
            sessions: List.from(_sessions),
            currentSessionId: _currentSessionId,
            currentField: _currentField,
            selectedLocale: _selectedLocale,
          ),
        );
        await _saveSessions();
        return;
      }
    }

    currentMessages.add('You: $message');
    // Update title based on first message
    if (currentMessages.length == 1 ||
        _sessions[currentSessionIndex].title == 'New Chat' ||
        _sessions[currentSessionIndex].title == 'محادثة جديدة') {
      _sessions[currentSessionIndex] = ChatSession(
        id: _sessions[currentSessionIndex].id,
        title: message.length > 30 ? '${message.substring(0, 30)}...' : message,
        messages: currentMessages,
      );
    }

    emit(
      ChatLoaded(
        List.from(currentMessages),
        sessions: List.from(_sessions),
        currentSessionId: _currentSessionId,
        currentField: _currentField,
        selectedLocale: _selectedLocale,
      ),
    );
    await _saveSessions();

    try {
      final aiResponse = await _aiService.sendMessage(
        message,
        List.from(currentMessages),
      );
      currentMessages.add('AI: $aiResponse');

      emit(
        ChatLoaded(
          List.from(currentMessages),
          sessions: List.from(_sessions),
          currentSessionId: _currentSessionId,
          currentField: _currentField,
          selectedLocale: _selectedLocale,
        ),
      );
      await _saveSessions();
      _detectCurrentField();
    } catch (e) {
      emit(
        ChatError(
          'حصل مشكلة في الاتصال: $e',
          List.from(currentMessages),
          sessions: List.from(_sessions),
          currentSessionId: _currentSessionId,
          currentField: _currentField,
          selectedLocale: _selectedLocale,
        ),
      );
    }
  }

  Future<void> pickImage() async {
    final currentSessionIndex = _sessions.indexWhere(
      (s) => s.id == _currentSessionId,
    );
    if (currentSessionIndex == -1) return;
    final currentMessages = _sessions[currentSessionIndex].messages;

    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final attachmentUrl = 'Image from gallery: ${image.name}';
        currentMessages.add('You: [Attached Image] $attachmentUrl');
        emit(
          ChatLoaded(
            List.from(currentMessages),
            sessions: List.from(_sessions),
            currentSessionId: _currentSessionId,
            currentField: _currentField,
            selectedLocale: _selectedLocale,
          ),
        );
        await _saveSessions();

        currentMessages.add(
          'AI: تمام، تم حفظ الصورة كنموذج أعمال. هل فيه حاجة تانية حابب تضيفها؟',
        );
        emit(
          ChatLoaded(
            List.from(currentMessages),
            sessions: List.from(_sessions),
            currentSessionId: _currentSessionId,
            currentField: _currentField,
            selectedLocale: _selectedLocale,
          ),
        );
        await _saveSessions();
      }
    } catch (e) {
      emit(
        ChatError(
          'مش قادرين نفتح الملفات. لو لسه ضايف الميزة دي، لازم تقفل البرنامج وتفتحه تاني (Full Restart) عشان تشتغل.',
          List.from(currentMessages),
          sessions: List.from(_sessions),
          currentSessionId: _currentSessionId,
          currentField: _currentField,
          selectedLocale: _selectedLocale,
        ),
      );
    }
  }

  Future<void> clearChat() async {
    await deleteSession(_currentSessionId);
  }

  Future<void> toggleListening() async {
    final currentSessionIndex = _sessions.indexWhere(
      (s) => s.id == _currentSessionId,
    );
    if (currentSessionIndex == -1) return;
    final currentMessages = _sessions[currentSessionIndex].messages;

    // If already listening, stop it
    if (_voiceService.isListening) {
      try {
        await _voiceService.stopListening();
        emit(
          ChatLoaded(
            List.from(currentMessages),
            isListening: false,
            sessions: List.from(_sessions),
            currentSessionId: _currentSessionId,
            currentField: _currentField,
            selectedLocale: _selectedLocale,
          ),
        );
      } catch (e) {
        print('Error stopping listening: $e');
        // Even if stopping fails, update the UI
        emit(
          ChatLoaded(
            List.from(currentMessages),
            isListening: false,
            sessions: List.from(_sessions),
            currentSessionId: _currentSessionId,
            currentField: _currentField,
            selectedLocale: _selectedLocale,
          ),
        );
      }
      return;
    }

    // Start listening
    try {
      print('Attempting to start listening with locale: $_selectedLocale');

      final available = await _voiceService.startListening((text) {
        print('Voice result received: $text');
        if (text.isNotEmpty) {
          // Stop listening after receiving text
          _voiceService.stopListening();
          // Send the message
          sendMessage(text);
        }
      }, localeId: _selectedLocale);

      print('Voice service available: $available');

      if (available) {
        emit(
          ChatLoaded(
            List.from(currentMessages),
            isListening: true,
            sessions: List.from(_sessions),
            currentSessionId: _currentSessionId,
            currentField: _currentField,
            selectedLocale: _selectedLocale,
          ),
        );
      } else {
        // Service not available (permission denied or initialization failed)
        emit(
          ChatError(
            'المايك مش شغال يا بطل، اتأكد من الصلاحيات أو جرب تكتب.',
            List.from(currentMessages),
            sessions: List.from(_sessions),
            currentSessionId: _currentSessionId,
            currentField: _currentField,
            selectedLocale: _selectedLocale,
          ),
        );
      }
    } catch (e, stackTrace) {
      print('Error in toggleListening: $e');
      print('Stack trace: $stackTrace');

      // Provide more specific error message
      String errorMessage = 'حصلت مشكلة في المايك: $e';

      if (e.toString().contains('permission')) {
        errorMessage =
            'المايك محتاج صلاحيات. روح للإعدادات وفعّل صلاحية المايكروفون.';
      } else if (e.toString().contains('initialize')) {
        errorMessage = 'مش قادرين نشغل المايك. جرب تقفل البرنامج وتفتحه تاني.';
      }

      emit(
        ChatError(
          errorMessage,
          List.from(currentMessages),
          sessions: List.from(_sessions),
          currentSessionId: _currentSessionId,
          currentField: _currentField,
          selectedLocale: _selectedLocale,
        ),
      );
    }
  }

  Future<void> generateCV() async {
    final currentSessionIndex = _sessions.indexWhere(
      (s) => s.id == _currentSessionId,
    );
    if (currentSessionIndex == -1) return;
    final currentMessages = _sessions[currentSessionIndex].messages;

    try {
      // Check for main data before allowing generation
      final history = currentMessages.join('\n').toLowerCase();
      final hasName = history.contains('اسم') || history.contains('name');
      final hasEmail = history.contains('@');
      final hasPhone = history.contains('01') || history.contains('+');
      final hasJobTitle =
          history.contains('مسمى') ||
          history.contains('عنوان') ||
          history.contains('job');

      if (!hasName || !hasEmail || !hasPhone || !hasJobTitle) {
        emit(
          ChatError(
            'لسه محتاجين نجمع باقي البيانات الأساسية (الاسم، البريد، الهاتف، المسمى الوظيفي) عشان نقدر نعمل الـ CV.',
            List.from(currentMessages),
            sessions: List.from(_sessions),
            currentSessionId: _currentSessionId,
            currentField: _currentField,
            selectedLocale: _selectedLocale,
          ),
        );
        return;
      }

      emit(
        ChatLoading(
          sessions: List.from(_sessions),
          currentSessionId: _currentSessionId,
          currentField: _currentField,
          selectedLocale: _selectedLocale,
        ),
      );
      final jsonString = await _aiService.generateCV(currentMessages);

      // Clean up JSON string if it contains markdown code blocks
      final cleanJson = jsonString
          .replaceAll('```json', '')
          .replaceAll('```', '');

      final Map<String, dynamic> jsonData = jsonDecode(cleanJson);
      final cvModel = CVModel.fromJson(jsonData);

      // Instead of generating PDF, we go to review state
      emit(
        ChatReview(
          List.from(currentMessages),
          cvModel,
          sessions: List.from(_sessions),
          currentSessionId: _currentSessionId,
          currentField: _currentField,
          selectedLocale: _selectedLocale,
        ),
      );
    } catch (e) {
      emit(
        ChatError(
          'حصل مشكلة واحنا بنجمع بياناتك: $e',
          List.from(currentMessages),
          sessions: List.from(_sessions),
          currentSessionId: _currentSessionId,
          currentField: _currentField,
          selectedLocale: _selectedLocale,
        ),
      );
    }
  }

  Future<void> finalizePdf(CVModel validatedData) async {
    final currentSessionIndex = _sessions.indexWhere(
      (s) => s.id == _currentSessionId,
    );
    if (currentSessionIndex == -1) return;
    final currentMessages = _sessions[currentSessionIndex].messages;

    try {
      emit(
        ChatLoading(
          sessions: List.from(_sessions),
          currentSessionId: _currentSessionId,
          currentField: _currentField,
          selectedLocale: _selectedLocale,
        ),
      );

      final file = await _pdfService.generatePdf(validatedData);

      await Printing.layoutPdf(
        onLayout: (format) => file.readAsBytes(),
        name: '${validatedData.fullName}_Seera_CV.pdf',
      );

      currentMessages.add('AI: تم تجهيز الـ CV يا بطل! ربنا يوفقك.');
      emit(
        ChatLoaded(
          List.from(currentMessages),
          sessions: List.from(_sessions),
          currentSessionId: _currentSessionId,
          currentField: _currentField,
          selectedLocale: _selectedLocale,
        ),
      );
      await _saveSessions();
    } catch (e) {
      emit(
        ChatError(
          'حصل مشكلة في الطباعة: $e',
          List.from(currentMessages),
          sessions: List.from(_sessions),
          currentSessionId: _currentSessionId,
          currentField: _currentField,
          selectedLocale: _selectedLocale,
        ),
      );
    }
  }

  Future<void> updateLocale(String locale) async {
    _selectedLocale = locale;
    await _voiceService.setLocale(locale);
    final currentSession = _sessions.firstWhere(
      (s) => s.id == _currentSessionId,
    );
    emit(
      ChatLoaded(
        List.from(currentSession.messages),
        sessions: List.from(_sessions),
        currentSessionId: _currentSessionId,
        currentField: _currentField,
        selectedLocale: _selectedLocale,
      ),
    );
    await _saveSessions();
  }
}
