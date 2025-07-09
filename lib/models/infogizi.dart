// lib/models/infogizi.dart

class Infogizi {
  final int id;
  final double calories;
  final double proteins;
  final double fat;
  final double carbohydrate;
  final String name;
  final String image;
  final DateTime? createdAt; // Ubah menjadi nullable
  final DateTime? updatedAt; // Ubah menjadi nullable

  Infogizi({
    required this.id,
    required this.calories,
    required this.proteins,
    required this.fat,
    required this.carbohydrate,
    required this.name,
    required this.image,
    this.createdAt, // Tidak lagi required
    this.updatedAt, // Tidak lagi required
  });

  factory Infogizi.fromJson(Map<String, dynamic> json) {
    // Fungsi helper untuk parsing double yang aman (tetap sama)
    double _parseToDouble(dynamic value) {
      if (value is num) {
        return value.toDouble();
      } else if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return 0.0;
    }

    // Fungsi helper untuk parsing DateTime yang aman
    DateTime? _parseToDateTime(dynamic value) {
      if (value is String && value.isNotEmpty) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return Infogizi(
      id: json['id'],
      calories: _parseToDouble(json['calories']),
      proteins: _parseToDouble(json['proteins']),
      fat: _parseToDouble(json['fat']),
      carbohydrate: _parseToDouble(json['carbohydrate']),
      name: json['name'],
      // Pastikan 'image' tidak null. Jika null, berikan string kosong atau placeholder.
      image: json['image'] as String? ?? 'https://placehold.co/200x100/CCCCCC/000000?text=No+Image',
      createdAt: _parseToDateTime(json['created_at']), // Gunakan helper untuk nullable DateTime
      updatedAt: _parseToDateTime(json['updated_at']), // Gunakan helper untuk nullable DateTime
    );
  }

  // Metode toJson (opsional, jika Anda perlu mengirim data Infogizi ke API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'calories': calories,
      'proteins': proteins,
      'fat': fat,
      'carbohydrate': carbohydrate,
      'name': name,
      'image': image,
      'created_at': createdAt?.toIso8601String(), // Gunakan ?. untuk nullable
      'updated_at': updatedAt?.toIso8601String(), // Gunakan ?. untuk nullable
    };
  }
}