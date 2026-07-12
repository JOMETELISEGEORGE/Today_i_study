import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_plan_item.dart';

class DailyPlanStorage {
  static const String _key = 'daily_plan_items';

  static Future<List<DailyPlanItem>> loadForToday() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);

    if (data == null) return [];

    final List decoded = jsonDecode(data);
    final today = DateTime.now();

    return decoded
        .map((e) => DailyPlanItem.fromMap(e))
        .where((item) =>
            item.date.year == today.year &&
            item.date.month == today.month &&
            item.date.day == today.day)
        .toList();
  }

  static Future<void> save(List<DailyPlanItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded =
        jsonEncode(items.map((i) => i.toMap()).toList());
    await prefs.setString(_key, encoded);
  }

  static Future<void> toggle(String id) async {
    final items = await loadForToday();
    for (var item in items) {
      if (item.id == id) {
        item.isCompleted = !item.isCompleted;
        break;
      }
    }
    await save(items);
  }

  static Future<void> clearToday() async {
    await save([]);
  }
}
