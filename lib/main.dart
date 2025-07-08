import 'package:fitly_v1/views/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitly_v1/controller/auth_controller.dart';
import 'package:fitly_v1/controller/article_controller.dart';
import 'package:fitly_v1/controller/recommendation_controller.dart'; // Import RecommendationController
import 'package:fitly_v1/views/main_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan Flutter binding terinisialisasi

  // Inisialisasi AuthController
  final authController = AuthController();
  debugPrint('Main: Calling loadUserFromPrefs...');
  await authController
      .loadUserFromPrefs(); // Tunggu hingga user dimuat dari SharedPreferences
  debugPrint(
    'Main: loadUserFromPrefs completed. User is logged in: ${authController.isLoggedIn}',
  );
  debugPrint(
    'Main: Initial user name: ${authController.userName}, Initial email: ${authController.userEmail}',
  );

  // Inisialisasi ArticleController
  final articleController = ArticleController();

  // Inisialisasi RecommendationController
  final recommendationController = RecommendationController();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>.value(value: authController),
        ChangeNotifierProvider<ArticleController>.value(
          value: articleController,
        ),
        ChangeNotifierProvider<RecommendationController>.value(
          value: recommendationController,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color(0xFFA4DD00),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}