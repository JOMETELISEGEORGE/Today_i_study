import 'package:flutter/material.dart';
import '../services/subject_storage.dart';
import '../models/subject_model.dart';
import '../widgets/confirm_delete_dialog.dart';
import 'add_subject_page.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  late Future<List<Subject>> _subjectsFuture;

  @override
  void initState() {
    super.initState();
    _subjectsFuture = SubjectStorage.load();
  }

  void _refresh() {
    setState(() {
      _subjectsFuture = SubjectStorage.load();
    });
  }

  Future<void> _deleteSubject(Subject subject) async {
    final confirm =
        await showConfirmDeleteDialog(context, subject.name);
    if (confirm == true) {
      await SubjectStorage.delete(subject.id);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subjects")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddSubjectPage(),
            ),
          );
          _refresh();
        },
      ),
      body: FutureBuilder<List<Subject>>(
        future: _subjectsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final subjects = snapshot.data!;
          if (subjects.isEmpty) {
            return const Center(
              child: Text("No subjects added yet."),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final s = subjects[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(s.name),
                  subtitle: Text(
                    "Exam in ${s.daysLeft} days\n"
                    "Modules: ${s.completedModules}/${s.totalModules}",
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteSubject(s),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
