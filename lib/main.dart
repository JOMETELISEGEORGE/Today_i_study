import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme/ocean_theme.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'services/auth_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(const TodayIStudy());
}

Future<void> _setGroqApiKeyOnce() async {
  final prefs = await SharedPreferences.getInstance();

  // Replace with your real Groq API key
  await prefs.setString(
    'groq_api_key',
    '',
  );
}

class TodayIStudy extends StatelessWidget {
  const TodayIStudy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Today I Study',
      debugShowCheckedModeBanner: false,
      theme: OceanTheme.theme,

      home: FutureBuilder<bool>(
        future: AuthService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data == true) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
