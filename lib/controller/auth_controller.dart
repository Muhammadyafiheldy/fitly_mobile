import 'package:fitly_v1/models/user.dart';
import 'package:fitly_v1/service/api_service.dart';
import 'package:flutter/material.dart';

class AuthController with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await ApiService.login(email, password);
      print('Login successful, user: $_user');
    } catch (e) {
      _user = null;
      print('Login failed: $e');
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await ApiService.register(name, email, password);
      print('Register successful, user: $_user');
      if (_user != null) {
        Navigator.pushReplacementNamed(
          navigatorKey.currentContext!,
          '/login',
        ); // Kembali ke login setelah register
      }
    } catch (e) {
      _user = null;
      print('Register failed: $e');
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tambahkan NavigatorKey di atas class
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
