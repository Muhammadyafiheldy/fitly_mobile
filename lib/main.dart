import 'package:fitly_v1/views/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import Controllers
import 'package:fitly_v1/controller/auth_controller.dart';
import 'package:fitly_v1/controller/article_controller.dart';
import 'package:fitly_v1/controller/recommendation_controller.dart';
import 'package:fitly_v1/controller/notification_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi AuthController
  final authController = AuthController();

  debugPrint('Main: Calling loadUserFromPrefs...');
  await authController.loadUserFromPrefs(); // Akan ambil user + token dari prefs
  debugPrint('Main: loadUserFromPrefs completed. User is logged in: ${authController.isLoggedIn}');
  debugPrint('Main: Initial user name: ${authController.userName}, Initial email: ${authController.userEmail}');

  // Inisialisasi Controller lainnya
  final articleController = ArticleController();
  final recommendationController = RecommendationController();
  final notificationController = NotificationController();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>.value(value: authController),
        ChangeNotifierProvider<ArticleController>.value(value: articleController),
        ChangeNotifierProvider<RecommendationController>.value(value: recommendationController),
        ChangeNotifierProvider<NotificationController>.value(value: notificationController),
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
