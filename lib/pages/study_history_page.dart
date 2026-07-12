import 'package:flutter/material.dart';
import '../services/study_session_storage.dart';
import '../utils/study_stats.dart';

class StudyHistoryPage extends StatelessWidget {
  const StudyHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Study History")),
      body: FutureBuilder(
        future: StudySessionStorage.loadSessions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final sessions = snapshot.data!;
          if (sessions.isEmpty) {
            return const Center(child: Text("No sessions yet."));
          }

          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(16),
                child: ListTile(
                  title: const Text("📊 Progress Summary"),
                  subtitle: Text(
                    "Total Time: ${StudyStats.totalMinutes(sessions)} min\n"
                    "Sessions: ${StudyStats.totalSessions(sessions)}\n"
                    "Top Topic: ${StudyStats.topTopic(sessions)}",
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, i) {
                    final s = sessions[i];
                    return ListTile(
                      title: Text(s.topic),
                      subtitle:
                          Text("${s.minutes} min • ${s.date.toLocal()}"),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
