// lib/views/home.dart

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
import 'package:fitly_v1/controller/notification_controller.dart'; // Import NotificationController

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
    // Muat data pengguna jika belum dimuat
    final auth = Provider.of<AuthController>(context, listen: false);
    if (!auth.isUserLoaded) {
      auth.loadUserFromPrefs();
    }

    // Panggil fetchUnreadCount segera setelah widget dibangun
    // Ini memastikan badge notifikasi diperbarui saat pertama kali masuk Home
    Future.microtask(() {
      Provider.of<NotificationController>(context, listen: false).fetchUnreadCount();
    });
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
                // Display user profile picture
                // Jika ingin menggunakan gambar profil dari URL (misal dari AuthController)
                // Hapus komentar pada kode di bawah dan pastikan AuthController.userProfileImageUrl berfungsi
                /*
                Consumer<AuthController>(
                  builder: (context, authController, child) {
                    final imageUrl = authController.userProfileImageUrl;
                    return CircleAvatar(
                      radius: 24,
                      backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                          ? CachedNetworkImageProvider(imageUrl) as ImageProvider
                          : const AssetImage('assets/img/profil.jpg'), // Default local asset
                    );
                  },
                ),
                */
                // Menggunakan gambar profil lokal secara default
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
                // Notification Icon with Badge
                Consumer<NotificationController>(
                  builder: (context, notificationController, child) {
                    final unreadCount = notificationController.unreadCount;
                    return Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none,
                              color: Colors.white),
                          onPressed: () async {
                            // Ambil notifikasi terbaru dari backend sebelum navigasi
                            // Ini penting agar NotificationPage menampilkan status 'dibaca' yang paling baru
                            await notificationController.fetchNotificationsFromBackend();
                            // Navigasi ke halaman notifikasi
                            // Menggunakan .then() untuk memicu pembaruan unreadCount setelah kembali
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotificationPage(),
                              ),
                            ).then((_) {
                              // Setelah kembali dari NotificationPage, perbarui jumlah notifikasi yang belum dibaca
                              // Ini akan menghilangkan badge merah jika semua notifikasi sudah dibaca
                              notificationController.fetchUnreadCount();
                            });
                          },
                        ),
                        // Tampilkan badge merah jika ada notifikasi belum dibaca
                        if (unreadCount > 0)
                          Positioned(
                            right: 11,
                            top: 11,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                              child: Text(
                                '$unreadCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          // Scrollable content
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