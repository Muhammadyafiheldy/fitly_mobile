import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitly_v1/controller/notification_controller.dart';
import 'package:fitly_v1/models/notification_model.dart';
import 'package:fitly_v1/widget/article_detail_screen.dart'; // Import halaman detail artikel Anda
import 'package:fitly_v1/widget/recommendation_detail_screen.dart'; // Import halaman detail rekomendasi Anda
import 'package:fitly_v1/service/api_service.dart'; // Import ApiService untuk fetching data
import 'package:fitly_v1/models/article.dart'; // Import model Article
import 'package:fitly_v1/models/recommendation.dart'; // Import model Recommendation


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
      // Mengubah panggilan dari markAllNotificationsAsRead menjadi markAllAsRead
      notificationController.markAllAsRead(); //
    });
  }

  // Fungsi async untuk menangani navigasi dan fetching data detail
  Future<void> _navigateToDetail(AppNotification notif) async {
    final notificationController = Provider.of<NotificationController>(context, listen: false);

    // Tandai notifikasi sebagai dibaca saat diklik
    // Menggunakan markAsRead karena sudah ada di controller Anda
    if (!notif.isRead) {
      await notificationController.markAsRead(notif.id); //
    }

    // Tampilkan loading indicator
    showDialog(
      context: context,
      barrierDismissible: false, // Tidak bisa ditutup dengan tap di luar
      builder: (BuildContext dialogContext) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      if (notif.relatedType == 'article' && notif.relatedId != null) {
        // Fetch objek Article lengkap dari API
        final Article article = await ApiService.fetchArticleById(notif.relatedId!); //
        
        // Tutup dialog loading
        Navigator.of(context, rootNavigator: true).pop();

        // Navigasi ke ArticleDetailScreen dengan objek Article
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      } else if (notif.relatedType == 'recommendation' && notif.relatedId != null) {
        // Fetch objek Recommendation lengkap dari API
        final Recommendation recommendation = await ApiService.fetchRecommendationById(notif.relatedId!); //
        
        // Tutup dialog loading
        Navigator.of(context, rootNavigator: true).pop();

        // Navigasi ke RecommendationDetailScreen dengan objek Recommendation
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecommendationDetailScreen(recommendation: recommendation),
          ),
        );
      } else {
        // Tutup dialog loading
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada detail terkait untuk notifikasi ini.')),
        );
      }
    } catch (e) {
      // Tutup dialog loading jika ada error
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat detail: $e')),
      );
      debugPrint('Error fetching detail for notification ${notif.id}: $e');
    } finally {
      // Panggil ini setelah kembali dari halaman detail atau jika terjadi error
      // untuk memastikan badge di home diperbarui.
      notificationController.fetchUnreadCount(); //
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi Anda'),
        centerTitle: false,
        backgroundColor: const Color(0xFFA4DD00),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<NotificationController>(
        builder: (context, notificationController, child) {
          if (notificationController.isLoading && notificationController.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notificationController.errorMessage != null) {
            return Center(child: Text('Error: ${notificationController.errorMessage}'));
          }
          if (notificationController.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada notifikasi.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await notificationController.fetchNotificationsFromBackend(); //
              await notificationController.fetchUnreadCount(); //
            },
            child: ListView.builder(
              itemCount: notificationController.notifications.length,
              itemBuilder: (context, index) {
                final AppNotification notif = notificationController.notifications[index];
                
                // Icon default dan warna sesuai gambar
                IconData iconData = Icons.info_outline;
                Color circleAvatarBgColor = const Color(0xFFE3F2FD); // Light blue
                Color iconColor = Colors.blue;

                // Gaya teks untuk notifikasi yang belum dibaca (bold) dan sudah dibaca (normal)
                final TextStyle titleStyle = TextStyle(
                  fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
                  color: notif.isRead ? Colors.black87 : Colors.black, // sedikit lebih gelap jika belum dibaca
                );
                final TextStyle subtitleStyle = TextStyle(
                  color: notif.isRead ? Colors.grey[700] : Colors.black54, // sedikit lebih gelap jika belum dibaca
                );
                final TextStyle timeStyle = TextStyle(
                  fontSize: 12,
                  color: notif.isRead ? Colors.grey : Colors.grey[800],
                );

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      onTap: () => _navigateToDetail(notif),
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Hapus Notifikasi'),
                              content: const Text('Apakah Anda yakin ingin menghapus notifikasi ini?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Batal'),
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                    // Memanggil deleteNotification dari controller
                                    notificationController.deleteNotification(notif.id); //
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Notifikasi berhasil dihapus.')),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: circleAvatarBgColor,
                              child: Icon(iconData, color: iconColor, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(notif.title, style: titleStyle),
                                  const SizedBox(height: 4),
                                  Text(notif.subtitle, style: subtitleStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(notif.time, style: timeStyle),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}