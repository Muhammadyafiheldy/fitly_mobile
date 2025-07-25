import 'package:fitly_v1/controller/login_controller.dart';
import 'package:fitly_v1/views/main_nav.dart';
import 'package:fitly_v1/widget/background_shape.dart';
import 'package:fitly_v1/widget/custom_text_field.dart';
import 'package:fitly_v1/widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'register.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginController(),
      child: Scaffold(
        resizeToAvoidBottomInset:
            false, // agar background tidak ikut naik
        backgroundColor: const Color(0xFFF0FFF0),
        body: Stack(
          children: [
            const BackgroundShape(), // ini tetap di belakang
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    children: [
                      const SizedBox(height: 150),
                      const Text(
                        'Selamat Datang',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Email
                      Consumer<LoginController>(
                        builder:
                            (context, controller, _) => CustomTextField(
                              controller: controller.emailController,
                              hint: 'Masukkan email',
                            ),
                      ),
                      const SizedBox(height: 20),

                      // Password
                      Consumer<LoginController>(
                        builder:
                            (context, controller, _) => CustomTextField(
                              controller: controller.passwordController,
                              hint: 'Masukkan kata sandi',
                              obscureText: controller.obscurePassword,
                              errorText: controller.passwordError,
                              onToggleVisibility:
                                  controller.togglePasswordVisibility,
                            ),
                      ),
                      const SizedBox(height: 12),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Lupa kata sandi?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Login button
                      PrimaryButton(
                        text: "Login",
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainNavigation(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Belum punya akun?',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Daftar sekarang',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
