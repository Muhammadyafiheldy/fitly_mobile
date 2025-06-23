import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Dua tab: Rekomendasi & Artikel
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Info'),
          bottom: const TabBar(
            labelColor: Colors.green, // warna teks tab aktif
            unselectedLabelColor: Colors.grey, // warna teks tab tidak aktif
            indicatorColor: Colors.green, // warna garis bawah tab aktif
            tabs: [Tab(text: 'Rekomendasi'), Tab(text: 'Artikel')],
          ),
        ),
        body: const TabBarView(
          children: [RekomendasiListView(), ArtikelListView()],
        ),
      ),
    );
  }
}

// Contoh widget list Rekomendasi
class RekomendasiListView extends StatelessWidget {
  const RekomendasiListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh data dummy
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

// Contoh widget list Artikel
class ArtikelListView extends StatelessWidget {
  const ArtikelListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh data dummy
    final artikelList = ['Artikel 1', 'Artikel 2', 'Artikel 3'];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: artikelList.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            title: Text(artikelList[index]),
            subtitle: const Text('Ringkasan artikel...'),
            leading: const Icon(Icons.article),
          ),
        );
      },
    );
  }
}
