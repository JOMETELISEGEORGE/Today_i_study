import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ai/groq_client.dart';
import '../models/subject_model.dart';
import '../services/subject_storage.dart';

class AIPlannerPage extends StatefulWidget {
  const AIPlannerPage({super.key});

  @override
  State<AIPlannerPage> createState() => _AIPlannerPageState();
}

class _AIPlannerPageState extends State<AIPlannerPage> {
  static const String _storageKey = "today_ai_plan";

  bool loading = false;
  List<_PlanItem> planItems = [];
  List<Subject> subjects = [];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
    _loadSavedPlan();
  }

  // 🔹 Load subjects
  Future<void> _loadSubjects() async {
    final loaded = await SubjectStorage.load();
    if (!mounted) return;
    setState(() => subjects = loaded);
  }

  // 🔹 Load saved AI plan (with migration safety)
  Future<void> _loadSavedPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    if (data == null) return;

    final decoded = jsonDecode(data);

    // 🛡️ Migration fix: old versions stored List<String>
    if (decoded is List && decoded.isNotEmpty && decoded.first is String) {
      await prefs.remove(_storageKey);
      return;
    }

    if (!mounted) return;
    setState(() {
      planItems = (decoded as List)
          .map((e) => _PlanItem.fromMap(e))
          .toList();
    });
  }

  // 💾 Save plan
  Future<void> _savePlan() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(planItems.map((e) => e.toMap()).toList()),
    );
  }

  // 🧠 Generate AI plan (STAYS ON PAGE)
  Future<void> _generatePlan() async {
    if (subjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Add subjects first to generate a plan"),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
      planItems.clear();
    });

    final subjectContext = subjects.map((s) {
      return "${s.name} (Exam in ${s.daysLeft} days)";
    }).join(", ");

    final prompt = '''
I am a student preparing for exams.

My subjects and urgency:
$subjectContext

Create a realistic study plan ONLY for today.
Return 5 to 7 short checklist items.
Each item must be specific and actionable.
Do not include explanations, headings, or numbering.
''';

    try {
      final response = await GroqClient.chat(prompt);

      final items = response
          .split('\n')
          .map((e) => e.replaceAll(RegExp(r'^[-•*]\s*'), '').trim())
          .where((e) => e.isNotEmpty)
          .map((e) => _PlanItem(text: e, completed: false))
          .toList();

      if (!mounted) return;

      setState(() {
        planItems = items;
        loading = false;
      });

      await _savePlan();
    } catch (_) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to generate plan. Try again."),
        ),
      );
    }
  }

  void _toggleItem(int index) async {
    setState(() {
      planItems[index].completed =
          !planItems[index].completed;
    });
    await _savePlan();
  }

  void _regeneratePlan() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    setState(() => planItems.clear());
    _generatePlan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's AI Study Plan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Study Plan",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            const Text(
              "Based on your subjects and upcoming exams",
            ),
            const SizedBox(height: 20),

            // Generate button
            if (planItems.isEmpty)
              Center(
                child: ElevatedButton(
                  onPressed: loading ? null : _generatePlan,
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text("Generate Today’s Plan"),
                ),
              ),

            const SizedBox(height: 20),

            // Checklist
            if (planItems.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      "Today's Checklist",
                      style:
                          TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    ...planItems.asMap().entries.map(
                          (entry) => CheckboxListTile(
                            value: entry.value.completed,
                            title: Text(
                              entry.value.text,
                              style: TextStyle(
                                decoration:
                                    entry.value.completed
                                        ? TextDecoration
                                            .lineThrough
                                        : null,
                              ),
                            ),
                            onChanged: (_) =>
                                _toggleItem(entry.key),
                          ),
                        ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: _regeneratePlan,
                        child:
                            const Text("Regenerate Plan"),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Local checklist model
class _PlanItem {
  final String text;
  bool completed;

  _PlanItem({
    required this.text,
    required this.completed,
  });

  Map<String, dynamic> toMap() => {
        'text': text,
        'completed': completed,
      };

  factory _PlanItem.fromMap(Map<String, dynamic> map) {
    return _PlanItem(
      text: map['text'],
      completed: map['completed'],
    );
  }
}
