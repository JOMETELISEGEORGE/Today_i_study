import 'package:flutter/material.dart';

import '../services/auth_services.dart';
import 'login_page.dart';
import 'ai_planner_page.dart';
import 'subjects_page.dart';
import 'study_input_page.dart';
import 'study_history_page.dart';
import 'analytics_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today I Study"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.logout();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
          ),
        ],
      ),

      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              "Your study space",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            Text(
              "Plan • Execute • Reflect",
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 20),

            // 🎯 Today's Goal
            Card(
              color: Colors.blue.shade50,
              child: const ListTile(
                leading: Icon(Icons.flag),
                title: Text("Today’s Goal"),
                subtitle: Text(
                  "Complete focused study sessions with balance",
                ),
              ),
            ),

            const SizedBox(height: 28),

           
            _HomeCard(
              title: "🧠 Today’s AI Plan",
              subtitle: "Generate & track your study checklist",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AIPlannerPage(),
                  ),
                );
              },
            ),

            
            _HomeCard(
              title: "📘 Subjects",
              subtitle: "View, add, or delete exam subjects",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SubjectsPage(),
                  ),
                );
              },
            ),

            
            _HomeCard(
              title: "📚 Deep Study Mode",
              subtitle: "Break topics and focus with Pomodoro",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StudyInputPage(),
                  ),
                );
              },
            ),

            
            _HomeCard(
              title: "📊 Analytics",
              subtitle: "Track progress and readiness",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AnalyticsPage(),
                  ),
                );
              },
            ),

            
            _HomeCard(
              title: "🕒 Study History",
              subtitle: "View completed focus sessions",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StudyHistoryPage(),
                  ),
                );
              },
            ),

          
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HomeCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
