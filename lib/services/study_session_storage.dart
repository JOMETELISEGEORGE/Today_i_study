import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/study_session_model.dart';

class StudySessionStorage {
  static const String _key = 'study_sessions';

  static Future<void> save(StudySession session) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_key);

    List<StudySession> sessions = [];

    if (existing != null) {
      final List decoded = jsonDecode(existing);
      sessions = decoded.map((e) => StudySession.fromMap(e)).toList();
    }

    sessions.add(session);

    await prefs.setString(
      _key,
      jsonEncode(sessions.map((s) => s.toMap()).toList()),
    );
  }

  static Future<List<StudySession>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);

    if (data == null) return [];

    final List decoded = jsonDecode(data);
    return decoded.map((e) => StudySession.fromMap(e)).toList();
  }
}
