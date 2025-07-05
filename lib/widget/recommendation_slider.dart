import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitly_v1/models/recommendation.dart';
import 'package:fitly_v1/controller/recommendation_controller.dart';
import 'package:fitly_v1/widget/recommendation_detail_screen.dart'; // Pastikan path ini benar

class RecommendationSlider extends StatefulWidget {
  const RecommendationSlider({super.key});

  @override
  State<RecommendationSlider> createState() => _RecommendationSliderState();
}

class _RecommendationSliderState extends State<RecommendationSlider> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecommendationController>(context, listen: false).fetchRecommendations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecommendationController>(
      builder: (context, recommendationController, child) {
        if (recommendationController.isLoading) {
          return const SizedBox(
            height: 180, // Sesuaikan tinggi loading state
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (recommendationController.errorMessage != null) {
          return SizedBox(
            height: 180, // Sesuaikan tinggi error state
            child: Center(
              child: Text(
                recommendationController.errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (recommendationController.recommendations.isEmpty) {
          return const SizedBox(
            height: 180, // Sesuaikan tinggi empty state
            child: Center(child: Text("Tidak ada rekomendasi tersedia.")),
          );
        }

        return SizedBox(
          height: 180, // **Ubah tinggi keseluruhan slider menjadi 180**
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendationController.recommendations.length,
            itemBuilder: (context, index) {
              final recommendation = recommendationController.recommendations[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecommendationDetailScreen(recommendation: recommendation),
                    ),
                  );
                },
                child: Container(
                  width: 200, // Lebar item rekomendasi
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar Rekomendasi
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                        child: (recommendation.imageUrl != null && recommendation.imageUrl!.isNotEmpty)
                            ? Image.network(
                                recommendation.imageUrl!,
                                height: 100, // Tinggi gambar tetap 100, karena kita tambah tinggi container
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 100,
                                    width: double.infinity,
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: Icon(Icons.broken_image, size: 40, color: Colors.grey[400]),
                                    ),
                                  );
                                },
                              )
                            : Container( // Placeholder jika tidak ada gambar
                                height: 100,
                                width: double.infinity,
                                color: Colors.grey[200],
                                child: Center(
                                  child: Text(
                                    'No Image',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recommendation.type,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              recommendation.recommendationText,
                              maxLines: 2, // Tetap 2 baris, sekarang seharusnya ada cukup ruang
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}