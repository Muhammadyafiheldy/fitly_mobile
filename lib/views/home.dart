import 'package:fitly_v1/controller/my_carousel_controller.dart' as cs;
import 'package:fitly_v1/views/notification.dart';
import 'package:fitly_v1/widget/artikel_slider.dart';
import 'package:fitly_v1/widget/recommendation_slider.dart';
import 'package:fitly_v1/widget/carousel_banner.dart';
import 'package:fitly_v1/widget/shortcut_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitly_v1/controller/auth_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  final List<String> bannerImages = [
    'assets/img/beranda.png',
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600',
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600',
    'https://plus.unsplash.com/premium_photo-1671379086168-a5d018d583cf?w=600',
  ];

  final cs.MyCarouselController carouselController = cs.MyCarouselController();

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthController>(context, listen: false);
    if (!auth.isUserLoaded) {
      auth.loadUserFromPrefs();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 22),
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
                  child: Selector<AuthController, String>(
                    selector: (_, controller) => controller.userName,
                    builder: (_, name, __) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Selamat Datang",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            name,
                            style: const TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationPage()),
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
                const SizedBox(height: 24),

                const ShortcutMenu(),
                const SizedBox(height: 24),

                const Text(
                  "Artikel Terkini",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                const ArtikelSlider(),

                const SizedBox(height: 24),
                const Text(
                  "Rekomendasi",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                const RecommendationSlider(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
