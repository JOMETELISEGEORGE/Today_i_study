import 'groq_client.dart';

class AIStudy {
  /// Returns clean study subtopics for a given topic
  static Future<List<String>> getSubtopics(String topic) async {
    final prompt = """
Break the topic "$topic" into clear study subtopics.

Rules:
- Each subtopic must be 2–5 words only
- No explanations
- No full sentences
- No punctuation at the end
- Use syllabus-style phrasing
- Return as a simple numbered list
""";

    try {
      final response = await GroqClient.chat(prompt);

      // Split by lines and clean
      final lines = response
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      return lines;
    } catch (_) {
      // Safe fallback (never crash UI)
      return [
        "Concept overview",
        "Key definitions",
        "Important mechanisms",
        "Common problems",
        "Exam-focused points",
      ];
    }
  }
}
