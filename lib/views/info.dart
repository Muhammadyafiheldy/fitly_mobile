import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final List<String> filters = [
    'Semua',
    'Makanan',
    'Olahraga',
    'Tidur',
    'Vitamin',
    'Obat',
    'Kesehatan Mental',
    'Pola Hidup',
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const greenColor = Color(0xFFA4DD00);

    return Scaffold(
      appBar: AppBar(title: const Text('Info Rekomendasi')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Horizontal custom filter button
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: List.generate(filters.length, (index) {
                final isActive = selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CustomFilterButton(
                    label: filters[index],
                    isActive: isActive,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                );
              }),
            ),
          ),
          Divider(height: 0.5, color: Colors.grey[300]),
          const Expanded(child: RekomendasiListView()),
        ],
      ),
    );
  }
}

class CustomFilterButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const CustomFilterButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const greenColor = Color(0xFFA4DD00);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? greenColor : Colors.transparent,
          border: Border.all(color: greenColor, width: 0.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : greenColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// widget list Rekomendasi
class RekomendasiListView extends StatelessWidget {
  const RekomendasiListView({super.key});

  @override
  Widget build(BuildContext context) {
    final rekomendasiList = ['Rekomendasi 1', 'Rekomendasi 2', 'Rekomendasi 3'];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rekomendasiList.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            title: Text(rekomendasiList[index]),
            subtitle: const Text('Deskripsi rekomendasi...'),
            leading: const Icon(Icons.thumb_up_alt),
          ),
        );
      },
    );
  }
}
