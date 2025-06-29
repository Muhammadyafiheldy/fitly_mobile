import 'package:flutter/material.dart';
import 'package:fitly_v1/controller/register_controller.dart';
import 'package:fitly_v1/controller/auth_controller.dart';
import 'package:fitly_v1/views/login.dart';
import 'package:fitly_v1/widget/background_shape.dart';
import 'package:fitly_v1/widget/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final AuthController authController;
  late final RegisterController controller;

  @override
  void initState() {
    super.initState();
    authController = AuthController();
    controller = RegisterController(authController);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // cegah background ikut naik
      backgroundColor: const Color(0xFFF0FFF0),
      body: Stack(
        children: [
          const BackgroundShape(), // tetap berada di belakang
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  children: [
                    const SizedBox(height: 150),
                    const Text(
                      'Daftar Akun',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Nama
                    CustomTextField(
                      controller: controller.nameController,
                      hint: 'Masukkan Nama',
                      keyboardType: TextInputType.text,
                      errorText: controller.nameError,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    CustomTextField(
                      controller: controller.emailController,
                      hint: 'Masukkan email',
                      keyboardType: TextInputType.emailAddress,
                      errorText: controller.emailError,
                    ),
                    const SizedBox(height: 16),

                    // Password
                    CustomTextField(
                      controller: controller.passwordController,
                      hint: 'Masukkan kata sandi',
                      obscureText: !controller.isPasswordVisible,
                      errorText: controller.passwordError,
                      onToggleVisibility: () {
                        setState(() {
                          controller.togglePasswordVisibility();
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Tombol Daftar
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA4DD00),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Daftar',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        onPressed: () async {
                          final success = await controller.validateAndRegister(context);
                          setState(() {}); // refresh UI apa pun hasilnya

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Registrasi berhasil, Silahkan login'),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Sudah punya akun?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
