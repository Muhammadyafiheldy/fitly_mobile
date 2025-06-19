import 'package:fitly_v1/views/intro.dart';
import 'package:fitly_v1/views/login.dart';
import 'package:fitly_v1/views/main_nav.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstSeen();
  }

  Future<void> _checkFirstSeen() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    await Future.delayed(const Duration(seconds: 3)); // simulate splash delay

    if (!hasSeenIntro) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IntroScreen()),
      );
    } else if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/icon/splashicon.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
