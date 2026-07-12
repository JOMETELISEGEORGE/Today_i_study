import 'package:flutter/material.dart';
import 'study_page.dart';

class StudyInputPage extends StatefulWidget {
  const StudyInputPage({super.key});

  @override
  State<StudyInputPage> createState() => _StudyInputPageState();
}

class _StudyInputPageState extends State<StudyInputPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Deep Study")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("What concept are you focusing on right now?"),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration:
                  const InputDecoration(hintText: "e.g. OS – Deadlocks"),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        StudyPage(topic: controller.text.trim()),
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
