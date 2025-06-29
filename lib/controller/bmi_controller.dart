import 'package:flutter/material.dart';

/// Menyimpan semua controller input & state sederhana
/// yang dipakai di halaman BMI.
class BmiController {
  // Text field controller
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  // pilihan radio gender
  String? gender;

  /// Reset seluruh isian + pilihan gender
  void reset() {
    heightController.clear();
    weightController.clear();
    ageController.clear();
    gender = null;
  }

  /// Wajib dipanggil agar TextEditingController tidak bocor memori
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    ageController.dispose();
  }
}
