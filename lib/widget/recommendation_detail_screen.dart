import 'package:flutter/material.dart';
import 'package:fitly_v1/models/recommendation.dart';

class RecommendationDetailScreen extends StatelessWidget {
  final Recommendation recommendation;

  const RecommendationDetailScreen({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recommendation.type), // Atau judul lain yang sesuai
        backgroundColor: Color.fromARGB(255, 48, 221, 0), // Warna yang berbeda untuk rekomendasi
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Rekomendasi (opsional, bisa null)
            if (recommendation.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  recommendation.imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey[400]),
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 150,
                color: Colors.grey[200],
                child: Center(
                  child: Text(
                    'No Image Available',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Tipe Rekomendasi
            Text(
              recommendation.type,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            // Teks Rekomendasi
            Text(
              recommendation.recommendationText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),
            // Deskripsi (opsional, bisa null)
            if (recommendation.description != null)
              Text(
                recommendation.description!,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
