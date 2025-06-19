import 'package:fitly_v1/views/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  Future<void> _completeIntro(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            child: Center(
              child: Text(
                "Selamat datang di Fitly!\n\n(Desain intro kamu di sini)",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _completeIntro(context),
            child: const Text("Mulai"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
