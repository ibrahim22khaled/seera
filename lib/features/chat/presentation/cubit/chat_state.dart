part of 'chat_cubit.dart';

class ChatSession {
  final String id;
  final String title;
  final List<String> messages;

  ChatSession({required this.id, required this.title, required this.messages});

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'] ?? '',
      title: json['title'] ?? 'New Chat',
      messages: List<String>.from(json['messages'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'messages': messages,
  };
}

abstract class ChatState {
  final List<ChatSession> sessions;
  final String currentSessionId;
  final String? currentField;
  final String selectedLocale;

  ChatState({
    this.sessions = const [],
    this.currentSessionId = '',
    this.currentField,
    this.selectedLocale = 'ar-EG',
  });
}

class ChatInitial extends ChatState {
  ChatInitial({
    super.sessions,
    super.currentSessionId,
    super.currentField,
    super.selectedLocale,
  });
}

class ChatLoading extends ChatState {
  ChatLoading({
    super.sessions,
    super.currentSessionId,
    super.currentField,
    super.selectedLocale,
  });
}

class ChatLoaded extends ChatState {
  final List<String> messages;
  final bool isListening;

  ChatLoaded(
    this.messages, {
    this.isListening = false,
    super.sessions,
    super.currentSessionId,
    super.currentField,
    super.selectedLocale,
  });
}

class ChatError extends ChatState {
  final String message;
  final List<String> messages;

  ChatError(
    this.message,
    this.messages, {
    super.sessions,
    super.currentSessionId,
    super.currentField,
    super.selectedLocale,
  });
}

class ChatReview extends ChatState {
  final List<String> messages;
  final CVModel cvData;

  ChatReview(
    this.messages,
    this.cvData, {
    super.sessions,
    super.currentSessionId,
    super.currentField,
    super.selectedLocale,
  });
}
