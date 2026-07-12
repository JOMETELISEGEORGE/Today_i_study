import 'package:flutter/material.dart';
import '../ai/ai_study.dart';
import '../focus/pomodoro_page.dart';
import '../models/study_subtopic_item.dart';
import '../services/study_subtopic_storage.dart';

class StudyPage extends StatefulWidget {
  final String topic;

  const StudyPage({
    super.key,
    required this.topic,
  });

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  List<StudySubtopicItem> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadSubtopics();
  }

  Future<void> _loadSubtopics() async {
    final saved =
        await StudySubtopicStorage.load(widget.topic);

    if (saved.isNotEmpty) {
      setState(() {
        items = saved;
        loading = false;
      });
      return;
    }

    final aiResult =
        await AIStudy.getSubtopics(widget.topic);

    final cleaned = aiResult
        .map(
          (e) => StudySubtopicItem(
            parentTopic: widget.topic,
            text: _clean(e),
          ),
        )
        .toList();

    await StudySubtopicStorage.save(widget.topic, cleaned);

    setState(() {
      items = cleaned;
      loading = false;
    });
  }

  Future<void> _toggle(int index) async {
    setState(() {
      items[index].isCompleted = !items[index].isCompleted;
    });
    await StudySubtopicStorage.save(widget.topic, items);
  }

  String _clean(String text) {
    return text
        .replaceAll(RegExp(r'^[0-9\.\-\)\s]+'), '')
        .replaceAll('.', '')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Breakdown"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📘 Topic header
                  Text(
                    widget.topic,
                    style:
                        Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Check off what you’ve covered",
                    style:
                        Theme.of(context).textTheme.bodySmall,
                  ),

                  const SizedBox(height: 24),

                  // ✅ Checklist
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return CheckboxListTile(
                          value: item.isCompleted,
                          title: Text(
                            item.text,
                            style: TextStyle(
                              decoration: item.isCompleted
                                  ? TextDecoration
                                      .lineThrough
                                  : null,
                            ),
                          ),
                          onChanged: (_) => _toggle(index),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ⏱ Start focus
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PomodoroPage(
                            topic: widget.topic,
                          ),
                        ),
                      );
                    },
                    child: const Text("Start Focus Session"),
                  ),
                ],
              ),
      ),
    );
  }
}
