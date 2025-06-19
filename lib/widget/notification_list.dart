import 'package:flutter/material.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'Info',
        'message':
            'Lihat rekomendasi makanan yang sehat untuk program diet anda!',
        'time': '5 menit',
      },
      {
        'title': 'Info',
        'message': 'Jaga kesehatan tubuh dengan berolahraga',
        'time': '5 menit',
      },
      {
        'title': 'Info',
        'message':
            'Terus catat berat badan kamu dan lihat kemajuannya di masa mendatang!',
        'time': '14 Juni',
      },
    ];

    return ListView.separated(
      itemCount: notifications.length,
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final item = notifications[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: index == 0 ? const Color(0xFFEFFAF0) : Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, color: Colors.lightBlue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item['message']!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item['time']!,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
