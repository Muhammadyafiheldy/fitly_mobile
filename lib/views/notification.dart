import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy notifications list
    final notifications = [
      {
        'title': 'Workout Reminder',
        'subtitle': 'Don\'t forget your workout at 6 PM today!',
        'time': '5 mins ago',
      },
      {
        'title': 'New Achievement',
        'subtitle': 'You reached 10,000 steps today!',
        'time': '1 hour ago',
      },
      {
        'title': 'Friend Request',
        'subtitle': 'John Doe sent you a friend request.',
        'time': '2 hours ago',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:
          notifications.isEmpty
              ? const Center(
                child: Text(
                  'No notifications yet.',
                  style: TextStyle(fontSize: 16),
                ),
              )
              : ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  return ListTile(
                    leading: const Icon(Icons.notifications),
                    title: Text(notif['title']!),
                    subtitle: Text(notif['subtitle']!),
                    trailing: Text(
                      notif['time']!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  );
                },
              ),
    );
  }
}
