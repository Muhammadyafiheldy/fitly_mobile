import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitly_v1/controller/recommendation_controller.dart';
import 'package:fitly_v1/models/recommendation.dart';
import 'package:fitly_v1/widget/recommendation_detail_screen.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final List<String> filters = [
    'Semua',
    'Diet',
    'Bulking',
    'Olahraga',
    'Umum',
  ];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecommendationController>(context, listen: false).fetchRecommendations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Info Rekomendasi',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFA4DD00),
                Color(0xFF8CC63F),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: List.generate(filters.length, (index) {
                final isActive = selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CustomFilterButton(
                    label: filters[index],
                    isActive: isActive,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                );
              }),
            ),
          ),
          Divider(height: 0.5, color: Colors.grey[300]),
          Expanded(
            child: Consumer<RecommendationController>(
              builder: (context, controller, child) {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage != null) {
                  return Center(child: Text(controller.errorMessage!));
                }

                // Filter rekomendasi berdasarkan tipe yang dipilih
                final filteredList = selectedIndex == 0
                    ? controller.recommendations
                    : controller.recommendations.where((rec) => rec.type.toLowerCase() == filters[selectedIndex].toLowerCase()).toList();

                if (filteredList.isEmpty) {
                  return const Center(child: Text('Tidak ada rekomendasi tersedia untuk kategori ini.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final rec = filteredList[index];
                    return GestureDetector( // Gunakan GestureDetector di sini
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecommendationDetailScreen(recommendation: rec),
                          ),
                        );
                      },
                      child: Container( // Ini adalah wadah untuk card yang lebih besar
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [ // Tambahkan shadow seperti di ArticlePage
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row( // Gunakan Row untuk tata letak gambar dan teks
                          children: [
                            // Gambar Rekomendasi
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              child: rec.imageUrl != null && rec.imageUrl!.isNotEmpty
                                  ? Image.network(
                                      rec.imageUrl!,
                                      width: 100, // Ukuran gambar yang sama dengan artikel
                                      height: 100, // Ukuran gambar yang sama dengan artikel
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey[200],
                                          child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
                                        );
                                      },
                                    )
                                  : Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            // Judul dan Tipe Rekomendasi
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rec.recommendationText, // Judul rekomendasi
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 2, // Batasi baris
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Content: ${rec.type}', // Tipe rekomendasi
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );


              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomFilterButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const CustomFilterButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const greenColor = Color(0xFFA4DD00);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? greenColor : Colors.transparent,
          border: Border.all(color: greenColor, width: 0.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : greenColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}