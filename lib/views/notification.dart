import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitly_v1/controller/notification_controller.dart'; // Pastikan path benar
// import 'package:fitly_v1/views/article_detail_page.dart'; // Contoh: import halaman detail artikel
// import 'package:fitly_v1/views/recommendation_detail_page.dart'; // Contoh: import halaman detail rekomendasi

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    // Panggil fetch notifikasi saat halaman dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationController>(context, listen: false).fetchNotificationsFromBackend();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mengakses NotificationController menggunakan Consumer untuk rebuild otomatis
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<NotificationController>(
        builder: (context, notificationController, child) {
          if (notificationController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notificationController.errorMessage != null) {
            return Center(child: Text('Error: ${notificationController.errorMessage}'));
          }
          if (notificationController.notifications.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada notifikasi.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            itemCount: notificationController.notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notif = notificationController.notifications[index];
              IconData iconData;
              // Pilih ikon berdasarkan tipe notifikasi
              switch (notif['type']) {
                case 'new_article':
                  iconData = Icons.article;
                  break;
                case 'new_recommendation':
                  iconData = Icons.local_activity;
                  break;
                case 'workout_reminder':
                  iconData = Icons.fitness_center;
                  break;
                case 'achievement':
                  iconData = Icons.emoji_events;
                  break;
                default:
                  iconData = Icons.notifications;
              }

              // Ubah warna teks berdasarkan status 'is_read'
              final TextStyle titleStyle = TextStyle(
                fontWeight: notif['is_read'] ? FontWeight.normal : FontWeight.bold,
              );
              final TextStyle subtitleStyle = TextStyle(
                color: notif['is_read'] ? Colors.grey[700] : Colors.black87,
              );
              final TextStyle timeStyle = TextStyle(
                fontSize: 12,
                color: notif['is_read'] ? Colors.grey : Colors.grey[800],
              );

              return ListTile(
                leading: Icon(iconData, color: notif['is_read'] ? Colors.grey : Theme.of(context).primaryColor),
                title: Text(notif['title']!, style: titleStyle),
                subtitle: Text(notif['subtitle']!, style: subtitleStyle),
                trailing: Text(
                  notif['time']!,
                  style: timeStyle,
                ),
                onTap: () {
                  // Tandai notifikasi sudah dibaca saat ditekan
                  notificationController.markAsRead(notif['id'].toString());

                  // Logika navigasi berdasarkan tipe notifikasi
                  if (notif['type'] == 'new_article' && notif['article_id'] != null) {
                    // TODO: Ganti dengan navigasi ke halaman detail artikel Anda
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleDetailPage(articleId: notif['article_id'].toString())));
                    debugPrint('Navigating to article: ${notif['article_id']}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Membuka Artikel ID: ${notif['article_id']}')),
                    );
                  } else if (notif['type'] == 'new_recommendation' && notif['recommendation_id'] != null) {
                    // TODO: Ganti dengan navigasi ke halaman detail rekomendasi Anda
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendationDetailPage(recommendationId: notif['recommendation_id'].toString())));
                    debugPrint('Navigating to recommendation: ${notif['recommendation_id']}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Membuka Rekomendasi ID: ${notif['recommendation_id']}')),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}