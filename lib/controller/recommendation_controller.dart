import 'package:flutter/material.dart';
import 'package:fitly_v1/models/recommendation.dart';
import 'package:fitly_v1/service/api_service.dart';

class RecommendationController with ChangeNotifier {
  List<Recommendation> _recommendations = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Recommendation> get recommendations => _recommendations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRecommendations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _recommendations = await ApiService.getRecommendations();
    } catch (e) {
      _errorMessage = 'Gagal memuat rekomendasi: $e';
      print('Error fetching recommendations: $e'); 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}