import 'package:flutter/material.dart';

class BmiController {
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final ageController = TextEditingController();
  String? gender;

  void reset() {
    heightController.clear();
    weightController.clear();
    ageController.clear();
    gender = null;
  }

  void dispose() {
    heightController.dispose();
    weightController.dispose();
    ageController.dispose();
  }

  // Tambahkan fungsi kalkulasi BMI jika perlu
}
