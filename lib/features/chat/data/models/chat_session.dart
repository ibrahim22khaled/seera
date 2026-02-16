class ChatSession {
  final String id;
  final String title;
  final List<String> messages;

  ChatSession({required this.id, required this.title, required this.messages});

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'] ?? '',
      title: json['title'] ?? '__new_chat__',
      messages: List<String>.from(json['messages'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'messages': messages,
  };
}
