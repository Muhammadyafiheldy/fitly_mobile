import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:fitly_v1/models/article.dart'; // Import Article model
import 'package:fitly_v1/controller/article_controller.dart'; // Sesuaikan path jika berbeda
import 'package:fitly_v1/widget/article_detail_screen.dart'; // Import halaman detail

class ArtikelSlider extends StatefulWidget {
  const ArtikelSlider({super.key});

  @override
  State<ArtikelSlider> createState() => _ArtikelSliderState();
}

class _ArtikelSliderState extends State<ArtikelSlider> {
  @override
  void initState() {
    super.initState();
    // Panggil fetchArticles saat widget diinisialisasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ArticleController>(context, listen: false).fetchArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleController>(
      builder: (context, articleController, child) {
        if (articleController.isLoading) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (articleController.errorMessage != null) {
          return SizedBox(
            height: 100,
            child: Center(
              child: Text(
                articleController.errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (articleController.articles.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text("Tidak ada artikel tersedia.")),
          );
        }

        return SizedBox(
          height: 160, // Sesuaikan tinggi agar gambar dan teks muat
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: articleController.articles.length,
            itemBuilder: (context, index) {
              final article = articleController.articles[index];
              return GestureDetector(
                onTap: () {
                  // Navigasi ke halaman detail saat gambar diklik
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailScreen(article: article),
                    ),
                  );
                },
                child: Container(
                  width: 200,
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
                      // Gambar Artikel
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                        child: Image.network(
                          article.image,
                          height: 100, // Tinggi gambar
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
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          article.title,
                          maxLines: 2, // Batasi jumlah baris judul
                          overflow: TextOverflow.ellipsis, // Tampilkan elipsis jika judul terlalu panjang
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
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
