import 'package:fitly_v1/views/login.dart';
import 'package:fitly_v1/widget/background_shape.dart'; // Import background shape
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  Future<void> _completeIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundShape(), // Tambahkan background di paling belakang
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/icon/intro1.png',
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _completeIntro,
                child: const Text("Mulai"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
