// lib/pages/detail_nutrisi_page.dart

import 'package:flutter/material.dart';
import '../models/infogizi.dart'; // Sesuaikan path jika berbeda

class DetailNutrisiPage extends StatelessWidget {
  final Infogizi infogizi;

  const DetailNutrisiPage({Key? key, required this.infogizi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          infogizi.name, // Judul halaman detail adalah nama nutrisi
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFA4DD00),
                Color(0xFF6BCB77), // Pastikan warna gradient konsisten
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar besar
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  infogizi.image, // URL gambar dari objek Infogizi
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(Icons.image_not_supported, color: Colors.grey[600], size: 50),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Nama Makanan
            Text(
              infogizi.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 15),
            // Detail Nutrisi dalam Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Calories', '${infogizi.calories.toStringAsFixed(1)} kcal', Icons.local_fire_department),
                    const Divider(),
                    _buildDetailRow('Proteins', '${infogizi.proteins.toStringAsFixed(1)} g', Icons.egg),
                    const Divider(),
                    _buildDetailRow('Fat', '${infogizi.fat.toStringAsFixed(1)} g', Icons.oil_barrel),
                    const Divider(),
                    _buildDetailRow('Carbohydrate', '${infogizi.carbohydrate.toStringAsFixed(1)} g', Icons.rice_bowl),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Informasi tambahan (opsional)
            // Text(
            //   'Last Updated: ${infogizi.updatedAt.toLocal().toString().split(' ')[0]}',
            //   style: const TextStyle(
            //     fontSize: 12,
            //     color: Color(0xFF718096),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // Helper untuk baris detail
  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6BCB77), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }
}