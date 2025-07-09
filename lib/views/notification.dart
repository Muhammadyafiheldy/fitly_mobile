import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitly_v1/controller/notification_controller.dart';
import 'package:fitly_v1/models/notification_model.dart'; // Import AppNotification
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationController = Provider.of<NotificationController>(context, listen: false);
      notificationController.fetchNotificationsFromBackend();
      // Panggil juga untuk mendapatkan jumlah notifikasi belum dibaca saat halaman dimuat
      notificationController.fetchUnreadCount();
    });
  }

  @override
  Widget build(BuildContext context) {
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

          return RefreshIndicator( // Tambahkan RefreshIndicator
            onRefresh: () async {
              await notificationController.fetchNotificationsFromBackend();
              await notificationController.fetchUnreadCount();
            },
            child: ListView.separated(
              itemCount: notificationController.notifications.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final AppNotification notif = notificationController.notifications[index]; // Menggunakan AppNotification model
                IconData iconData;
                switch (notif.type) { // Akses properti langsung dari objek AppNotification
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

                final TextStyle titleStyle = TextStyle(
                  fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
                );
                final TextStyle subtitleStyle = TextStyle(
                  color: notif.isRead ? Colors.grey[700] : Colors.black87,
                );
                final TextStyle timeStyle = TextStyle(
                  fontSize: 12,
                  color: notif.isRead ? Colors.grey : Colors.grey[800],
                );

                return ListTile(
                  leading: Icon(iconData, color: notif.isRead ? Colors.grey : Theme.of(context).primaryColor),
                  title: Text(notif.title, style: titleStyle),
                  subtitle: Text(notif.subtitle, style: subtitleStyle),
                  trailing: Text(
                    notif.time,
                    style: timeStyle,
                  ),
                  onTap: () {
                    notificationController.markAsRead(notif.id);

                    // Logika navigasi berdasarkan tipe notifikasi
                    if (notif.relatedType == 'article' && notif.relatedId != null) {
                      // TODO: Ganti dengan navigasi ke halaman detail artikel Anda
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleDetailPage(articleId: notif.relatedId!)));
                      debugPrint('Navigating to article: ${notif.relatedId}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Membuka Artikel ID: ${notif.relatedId}')),
                      );
                    } else if (notif.relatedType == 'recommendation' && notif.relatedId != null) {
                      // TODO: Ganti dengan navigasi ke halaman detail rekomendasi Anda
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendationDetailPage(recommendationId: notif.relatedId!)));
                      debugPrint('Navigating to recommendation: ${notif.relatedId}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Membuka Rekomendasi ID: ${notif.relatedId}')),
                      );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}