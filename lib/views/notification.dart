import 'package:fitly_v1/widget/notification_list.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7FFE7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF79D17B), // Warna hijau
        elevation: 0,
        title: const Text('Notifikasi'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: const NotificationList(),
    );
  }
}
