import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Contoh data riwayat
    final List<Map<String, String>> historyData = [
      {'date': '2024-06-01', 'activity': 'Running', 'duration': '30 min'},
      {'date': '2024-06-02', 'activity': 'Cycling', 'duration': '45 min'},
      {'date': '2024-06-03', 'activity': 'Swimming', 'duration': '25 min'},
    ];

    return Scaffold(
      body: ListView.builder(
        itemCount: historyData.length,
        itemBuilder: (context, index) {
          final item = historyData[index];
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text(item['activity'] ?? ''),
            subtitle: Text(
              'Date: ${item['date']} - Duration: ${item['duration']}',
            ),
          );
        },
      ),
    );
  }
}
