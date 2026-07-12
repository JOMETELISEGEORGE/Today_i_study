import 'dart:convert';
import '../models/subject_model.dart';
import 'groq_client.dart';

class AIPlanner {
  /// Generates a structured daily study plan using AI
  static Future<Map<String, dynamic>> generatePlan(
    List<Subject> subjects,
    int availableHours,
  ) async {
    // If no subjects, return graceful fallback
    if (subjects.isEmpty) {
      return {
        "goal": "Add subjects to generate a plan",
        "plan": [],
        "reason": "No subjects were found in the system."
      };
    }

    final subjectSummary = subjects.map((s) {
      return "${s.name} – ${s.remainingModules} modules left, exam in ${s.daysLeft} days";
    }).join("\n");

    final prompt = """
You are an AI exam study planner.

Create a study plan ONLY for today.

Available study hours: $availableHours

Subjects:
$subjectSummary

Rules:
- Maximum 1 module per hour
- Prioritize subjects with nearest exams
- Prefer conceptual topics
- Avoid overload
- Be realistic

Return STRICTLY in this JSON format (no extra text):

{
  "goal": "One clear sentence describing today's study goal",
  "plan": [
    {
      "time": "Hour 1",
      "task": "Subject – Topic"
    },
    {
      "time": "Hour 2",
      "task": "Subject – Topic"
    }
  ],
  "reason": "Short explanation of why this plan was chosen"
}
""";

    try {
      final response = await GroqClient.chat(prompt);
      return _safeParse(response);
    } catch (e) {
      // Final safety fallback
      return {
        "goal": "Focus on consistent study",
        "plan": [],
        "reason": "AI service was unavailable."
      };
    }
  }

  /// Safely parses AI JSON output
  static Map<String, dynamic> _safeParse(String text) {
    try {
      final decoded = jsonDecode(text);

      return {
        "goal": decoded["goal"] ?? "Complete focused study sessions",
        "plan": decoded["plan"] ?? [],
        "reason":
            decoded["reason"] ?? "Based on exam urgency and workload"
      };
    } catch (_) {
      // Handles malformed AI responses
      return {
        "goal": "Complete focused study sessions",
        "plan": [],
        "reason": "AI response could not be structured properly."
      };
    }
  }
}
