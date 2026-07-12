import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subject_model.dart';

class SubjectStorage {
  static const String _key = 'subjects';

  static Future<List<Subject>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);

    if (data == null) return [];

    final List decoded = jsonDecode(data);
    return decoded.map((e) => Subject.fromMap(e)).toList();
  }

  static Future<void> save(List<Subject> subjects) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded =
        jsonEncode(subjects.map((s) => s.toMap()).toList());
    await prefs.setString(_key, encoded);
  }

  static Future<void> delete(String subjectId) async {
    final subjects = await load();
    subjects.removeWhere((s) => s.id == subjectId);
    await save(subjects);
  }
}
