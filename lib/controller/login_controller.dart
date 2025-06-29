import 'package:flutter/material.dart';
import 'package:fitly_v1/controller/auth_controller.dart';

class LoginController with ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController authController = AuthController();

  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  bool get obscurePassword => _obscurePassword;
  String? get emailError => _emailError ?? authController.errorMessage;
  String? get passwordError => _passwordError;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<bool> loginUser(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    _emailError = email.contains('@') ? null : 'Email harus mengandung @';
    _passwordError = password.length < 8 ? 'Kata sandi minimal 8 karakter' : null;

    if (_emailError != null || _passwordError != null) {
      notifyListeners();
      return false;
    }

    final success = await authController.login(email, password);
    notifyListeners();
    return success;
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }
}
