import 'package:fitly_v1/service/api_service.dart'; // Pastikan path ini benar

class Recommendation {
  final int id;
  final int? userId; // Nullable
  final String? userName; // Nullable
  final String recommendationText;
  final String? imageUrl; // Nullable
  final String type;
  final String? description; // Nullable
  final DateTime createdAt;

  Recommendation({
    required this.id,
    this.userId,
    this.userName,
    required this.recommendationText,
    this.imageUrl,
    required this.type,
    this.description,
    required this.createdAt,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    // Backend sudah mengembalikan 'image_url' sebagai URL lengkap (misal: http://.../storage/uploads/recommendations/abc.jpg)
    // Jadi, kita bisa langsung menggunakannya. Tidak perlu lagi menambahkan ApiService.baseImageUrl.
    String? finalImageUrl = json['image_url'] as String?;

    return Recommendation(
      id: json['id'] as int,
      userId: json['user_id'] as int?,
      userName: json['user_name'] as String?,
      recommendationText: json['recommendation_text'] as String,
      imageUrl: finalImageUrl, // Langsung pakai finalImageUrl
      type: json['type'] as String,
      description: json['description'] as String?,
      // Backend mengirim 'created_at' sebagai string DateTime lengkap, jadi bisa langsung di-parse
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}