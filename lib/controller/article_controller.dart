import 'package:flutter/material.dart';
import 'package:fitly_v1/models/article.dart'; // model Article yg kamu buat
import 'package:fitly_v1/service/api_service.dart';

class ArticleController with ChangeNotifier {
  List<Article> _articles = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchArticles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _articles = await ApiService.getArticles(); // ambil data dari API
    } catch (e) {
      _errorMessage = 'Gagal memuat artikel: $e';
      print('Error fetching articles: $e'); // Debugging
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}