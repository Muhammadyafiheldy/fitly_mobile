import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitly_v1/controller/auth_controller.dart';
import 'package:fitly_v1/views/main_nav.dart'; // ganti ke halaman awal kamu

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authController = AuthController();
  await authController.loadUserFromPrefs(); // load data user dari SharedPreferences

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>.value(value: authController),
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
      ),
      home: const MainNavigation(), // halaman pertama kamu
    );
  }
}
