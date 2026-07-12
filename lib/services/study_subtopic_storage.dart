import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/study_subtopic_item.dart';

class StudySubtopicStorage {
  static String _key(String topic) => 'subtopics_$topic';

  static Future<List<StudySubtopicItem>> load(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key(topic));

    if (data == null) return [];

    final List decoded = jsonDecode(data);
    return decoded
        .map((e) => StudySubtopicItem.fromMap(e))
        .toList();
  }

  static Future<void> save(
    String topic,
    List<StudySubtopicItem> items,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key(topic),
      jsonEncode(items.map((e) => e.toMap()).toList()),
    );
  }
}
