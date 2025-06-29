import 'package:flutter/material.dart';
import 'package:fitly_v1/controller/auth_controller.dart';

class RegisterController with ChangeNotifier {
  final AuthController authController;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? nameError;
  String? emailError;
  String? passwordError;
  bool isPasswordVisible = false;

  RegisterController(this.authController);

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<bool> validateAndRegister(BuildContext context) async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    nameError = name.isEmpty ? 'Nama harus diisi' : null;
    emailError = !email.contains('@') ? 'Email harus mengandung @' : null;
    passwordError = password.length < 8 ? 'Kata sandi minimal 8 karakter' : null;

    if (nameError != null || emailError != null || passwordError != null) {
      notifyListeners();
      return false;
    }

    final success = await authController.register(name, email, password);
    notifyListeners();
    return success;
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }
}
