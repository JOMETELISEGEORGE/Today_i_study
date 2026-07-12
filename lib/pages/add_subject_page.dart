import 'package:flutter/material.dart';
import '../models/subject_model.dart';
import '../services/subject_storage.dart';

class AddSubjectPage extends StatefulWidget {
  const AddSubjectPage({super.key});

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final nameController = TextEditingController();
  final modulesController = TextEditingController();
  DateTime examDate = DateTime.now();

  Future<void> saveSubject() async {
    if (nameController.text.isEmpty ||
        modulesController.text.isEmpty) {
      return;
    }

    final subjects = await SubjectStorage.load();

    subjects.add(
      Subject(
        id: DateTime.now().toString(),
        name: nameController.text.trim(),
        examDate: examDate,
        totalModules: int.parse(modulesController.text),
      ),
    );

    await SubjectStorage.save(subjects);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Subject")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(hintText: "Subject name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: modulesController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(hintText: "Total modules"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              child: const Text("Pick Exam Date"),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: examDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  setState(() => examDate = picked);
                }
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveSubject,
                child: const Text("Save Subject"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
