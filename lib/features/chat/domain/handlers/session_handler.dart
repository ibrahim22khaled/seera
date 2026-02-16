import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seera/features/chat/data/models/chat_session.dart';

class SessionHandler {
  List<ChatSession> sessions = [];
  String currentSessionId = '';

  Future<void> load(SharedPreferences prefs) async {
    final sessionsJson = prefs.getStringList('chat_sessions') ?? [];
    sessions.clear();
    for (var jsonStr in sessionsJson) {
      sessions.add(ChatSession.fromJson(jsonDecode(jsonStr)));
    }
    currentSessionId =
        prefs.getString('current_session_id') ??
        (sessions.isNotEmpty ? sessions.first.id : '');
  }

  Future<void> save(SharedPreferences prefs) async {
    final sessionsJson = sessions.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList('chat_sessions', sessionsJson);
    await prefs.setString('current_session_id', currentSessionId);
  }

  ChatSession get currentSession => sessions.firstWhere(
    (s) => s.id == currentSessionId,
    orElse: () => sessions.first,
  );
}
