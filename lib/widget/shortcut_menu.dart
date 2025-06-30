import 'package:fitly_v1/views/article.dart';
import 'package:fitly_v1/views/bmi.dart';
import 'package:fitly_v1/views/info.dart';
import 'package:flutter/material.dart';

class ShortcutMenu extends StatelessWidget {
  const ShortcutMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ShortcutIcon(
          icon: Icons.calculate,
          label: 'Kalkulator BMI',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BmiPage(),
              ), // ganti nanti dengan halaman yang sesuai
            );
          },
        ),
        _ShortcutIcon(
          icon: Icons.recommend,
          label: 'Rekomendasi',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InfoPage(),
              ), // ganti nanti dengan halaman yang sesuai
            );
          },
        ),
        _ShortcutIcon(
          icon: Icons.article,
          label: 'Artikel',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ArticlePage(),
              ), // ganti nanti dengan halaman yang sesuai
            );
          },
        ),
        _ShortcutIcon(
          icon: Icons.healing,
          label: 'Nutrisi',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InfoPage(),
              ), // ganti nanti dengan halaman yang sesuai
            );
          },
        ),
      ],
    );
  }
}

class _ShortcutIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ShortcutIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100, // Warna dasar neumorphic
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.white, // Bayangan atas kiri
                offset: Offset(-6, -6),
                blurRadius: 2,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Color(0xFFA7A9AF), // Bayangan bawah kanan
                offset: Offset(4, 4),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(icon, color: Colors.green, size: 28),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
