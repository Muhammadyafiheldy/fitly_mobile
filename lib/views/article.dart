import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  final List<Map<String, String>> articles = const [
    {
      'image':
          'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=800',
      'title': 'Pentingnya Sarapan untuk Kesehatan Tubuh',
      'date': '28 Juni 2025',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=800',
      'title': 'Pentingnya Sarapan untuk Kesehatan Tubuh',
      'date': '28 Juni 2025',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=800',
      'title': 'Pentingnya Sarapan untuk Kesehatan Tubuh',
      'date': '28 Juni 2025',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=800',
      'title': 'Pentingnya Sarapan untuk Kesehatan Tubuh',
      'date': '28 Juni 2025',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=800',
      'title': 'Pentingnya Sarapan untuk Kesehatan Tubuh',
      'date': '28 Juni 2025',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=800',
      'title': 'Pentingnya Sarapan untuk Kesehatan Tubuh',
      'date': '28 Juni 2025',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=800',
      'title': 'Pentingnya Sarapan untuk Kesehatan Tubuh',
      'date': '28 Juni 2025',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=800',
      'title': 'Pentingnya Sarapan untuk Kesehatan Tubuh',
      'date': '28 Juni 2025',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=800',
      'title': 'Pentingnya Sarapan untuk Kesehatan Tubuh',
      'date': '28 Juni 2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Semua Artikel"),
        backgroundColor: const Color(0xFFA4DD00),
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: articles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final article = articles[index];
          return GestureDetector(
            onTap: () {
              // Aksi ketika artikel diklik
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Gambar Artikel
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: Image.network(
                      article['image']!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Judul dan tanggal
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            article['date']!, // Tanggal dummy langsung
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
      ),
    );
  }
}
