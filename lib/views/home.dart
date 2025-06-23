import 'package:fitly_v1/controller/my_carousel_controller.dart' as cs;
import 'package:fitly_v1/views/notification.dart';
import 'package:fitly_v1/widget/artikel_slider.dart';
import 'package:fitly_v1/widget/carousel_banner.dart';
import 'package:fitly_v1/widget/shortcut_menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<String> bannerImages = [
    'assets/img/beranda.png',
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1671379086168-a5d018d583cf?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZnJ1aXR8ZW58MHx8MHx8fDA%3D',
  ];

  final cs.MyCarouselController carouselController = cs.MyCarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 237, 237),
      body: Column(
        children: [
          // Bagian atas hijau + konten user (tidak scrollable)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 22),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFA4DD00), Color(0xFF6BCB77)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/img/profil.jpg'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Selamat Datang",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Muhammad Yafi Heldy",
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Konten scrollable
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CarouselBanner(
                  imageUrls: bannerImages,
                  controller: carouselController,
                ),
                const SizedBox(height: 16),
                const ShortcutMenu(),
                const SizedBox(height: 24),
                const ArtikelSlider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
