import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitly_v1/models/user.dart';
import 'package:fitly_v1/service/api_service.dart';

class AuthController with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getter
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;
  String get userName => _user?.name ?? 'Guest';
  String get userEmail => _user?.email ?? '-';

  // Load user from SharedPreferences
  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_data');
    if (jsonString != null) {
      try {
        final jsonMap = jsonDecode(jsonString);
        _user = User.fromJson(jsonMap);
        notifyListeners();
      } catch (e) {
        _user = null;
        await prefs.remove('user_data');
      }
    }
  }

  // Save user to SharedPreferences
  Future<void> _saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user.toJson()));
  }

  // Clear user data from SharedPreferences
  Future<void> _clearUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
  }

  // Login method
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await ApiService.login(email, password);
      await _saveUserToPrefs(_user!);
      return true;
    } catch (e) {
      _user = null;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register method
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await ApiService.register(name, email, password);
      await _saveUserToPrefs(_user!);
      return true;
    } catch (e) {
      _user = null;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout method
  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ApiService.logout();
      _user = null;
      await _clearUserFromPrefs();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
