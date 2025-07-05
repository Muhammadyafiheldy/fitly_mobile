// lib/models/bmi_record_model.dart
class BmiRecord {
  final int id;
  final int? userId;
  final double height;
  final double weight;
  final int age;
  final String gender;
  final String activityLevel;
  final double bmi;
  final double bmr;
  final double tdee; // Tambahkan TDEE
  final String category;
  final DateTime recordedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  BmiRecord({
    required this.id,
    this.userId,
    required this.height,
    required this.weight,
    required this.age,
    required this.gender,
    required this.activityLevel,
    required this.bmi,
    required this.bmr,
    required this.tdee,
    required this.category,
    required this.recordedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor untuk membuat instance BmiRecord dari JSON
  factory BmiRecord.fromJson(Map<String, dynamic> json) {
    return BmiRecord(
      id: json['id'],
      userId: json['user_id'],
      height: double.parse(json['height'].toString()), // Pastikan double
      weight: double.parse(json['weight'].toString()), // Pastikan double
      age: json['age'],
      gender: json['gender'],
      activityLevel: json['activity_level'],
      bmi: double.parse(json['bmi'].toString()), // Pastikan double
      bmr: double.parse(json['bmr'].toString()), // Pastikan double
      tdee: double.parse(json['tdee'].toString()), // Pastikan double
      category: json['category'],
      recordedAt: DateTime.parse(json['recorded_at']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method untuk mengubah instance BmiRecord menjadi JSON (jika perlu mengirim ke API)
  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'age': age,
      'gender': gender,
      'activity_level': activityLevel,
      'bmi': bmi,
      'bmr': bmr,
      'tdee': tdee,
      // 'category' dan 'recorded_at' akan dihitung/dibuat di backend
      // 'user_id' akan otomatis diambil dari user yang login di backend
    };
  }
}