import 'package:flutter/material.dart';
import '../services/study_session_storage.dart';
import '../models/study_session_model.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  static const int targetMinutes = 300; // 🎯 5 hours target

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),
      ),
      body: FutureBuilder<List<StudySession>>(
        future: StudySessionStorage.loadSessions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No study data available yet"),
            );
          }

          final sessions = snapshot.data!;

          // 🔢 Total time
          final totalMinutes =
              sessions.fold<int>(0, (sum, s) => sum + s.minutes);

          // 📊 Overall progress (0.0 → 1.0)
          final progress =
              (totalMinutes / targetMinutes).clamp(0.0, 1.0);

          // 📚 Topic-wise breakdown
          final Map<String, int> byTopic = {};
          for (final s in sessions) {
            byTopic[s.topic] = (byTopic[s.topic] ?? 0) + s.minutes;
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🧠 Overall Progress
                const Text(
                  "Overall Study Progress",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(8),
                ),

                const SizedBox(height: 6),

                Text(
                  "$totalMinutes / $targetMinutes minutes",
                  style: Theme.of(context).textTheme.bodySmall,
                ),

                const SizedBox(height: 24),

                // ⏱ Summary cards
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.timer),
                    title: const Text("Total Study Time"),
                    subtitle: Text("$totalMinutes minutes"),
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: const Text("Total Sessions"),
                    subtitle: Text("${sessions.length} sessions"),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  "Topic-wise Breakdown",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: ListView(
                    children: byTopic.entries.map((e) {
                      return ListTile(
                        title: Text(e.key),
                        trailing: Text("${e.value} min"),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
