import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/groq_config.dart';

class GroqClient {
  static const String _endpoint =
      "https://api.groq.com/openai/v1/chat/completions";

  static Future<String> chat(String prompt) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        "Authorization": "Bearer ${GroqConfig.apiKey}",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "llama-3.1-8b-instant",
        "messages": [
          {
            "role": "system",
            "content":
                "You are an AI study assistant. Be concise, structured, and practical."
          },
          {
            "role": "user",
            "content": prompt
          }
        ],
        "temperature": 0.4
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final data = jsonDecode(response.body);
    return data["choices"][0]["message"]["content"];
  }
}
