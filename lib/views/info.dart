import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Tentang Fitly',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Fitly adalah aplikasi yang membantu Anda untuk hidup lebih sehat dengan berbagai fitur seperti pelacakan aktivitas, tips kesehatan, dan banyak lagi.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Versi: 1.0.0',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Dikembangkan oleh Tim Fitly',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
