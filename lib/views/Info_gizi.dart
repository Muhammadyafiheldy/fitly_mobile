// lib/pages/nutrisi_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitly_v1/models/infogizi.dart'; // Import model Infogizi
import 'package:fitly_v1/service/api_service.dart'; // Import ApiService
import 'package:fitly_v1/views/detail_infogizi.dart'; // Import DetailNutrisiPage

class NutrisiPage extends StatefulWidget {
  const NutrisiPage({Key? key}) : super(key: key);

  @override
  State<NutrisiPage> createState() => _NutrisiPageState();
}

class _NutrisiPageState extends State<NutrisiPage> {
  // TextEditingControllers for input dialogs (Keep if still used elsewhere)
  final TextEditingController _currentWeightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();
  final TextEditingController _targetDurationController = TextEditingController();

  // TextEditingController for search functionality
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = ''; // To store the current search query

  // Data Info Gizi dari API
  List<Infogizi> _allInfogiziData = []; // Menyimpan semua data dari API
  List<Infogizi> _displayedInfogiziData = []; // Data yang saat ini ditampilkan (6 item atau hasil search)
  bool _isLoading = true; // State untuk loading data
  String? _errorMessage; // State untuk error

  @override
  void initState() {
    super.initState();
    _fetchInfogiziData(); // Panggil fungsi untuk mengambil data
    _searchController.addListener(_onSearchChanged);
  }

  // Fungsi untuk mengambil data Info Gizi dari API
  Future<void> _fetchInfogiziData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final List<Infogizi> fetchedData = await ApiService.fetchAllInfogizi();
      setState(() {
        _allInfogiziData = fetchedData;
        _isLoading = false;
        _filterInfogiziData(); // Terapkan filter awal (limit 6 atau semua jika ada search)
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load nutrition data: $e';
        _isLoading = false;
      });
      print('Error fetching Infogizi: $e'); // Log error untuk debugging
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterInfogiziData(); // Panggil filter setiap kali query berubah
    });
  }

  // Fungsi untuk memfilter dan membatasi data yang ditampilkan
  void _filterInfogiziData() {
    List<Infogizi> filtered;

    if (_searchQuery.isEmpty) {
      // Jika tidak ada pencarian, tampilkan hanya 6 item pertama
      filtered = _allInfogiziData.take(6).toList();
    } else {
      // Jika ada pencarian, tampilkan semua yang cocok
      filtered = _allInfogiziData.where((infogizi) {
        final nameLower = infogizi.name.toLowerCase();
        final queryLower = _searchQuery.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
    }
    setState(() {
      _displayedInfogiziData = filtered;
    });
  }

  @override
  void dispose() {
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    _targetDurationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Info Nutrisi',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA4DD00), Color(0xFF6BCB77)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search nutrition info...', // Ubah hint text
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Info Nutrisi Terbaru', // Ubah teks header
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  // Sort By mungkin tidak relevan untuk data ini, bisa dihapus atau diadaptasi
                  // Jika ingin tetap ada, Anda perlu menambahkan logika sorting untuk _displayedInfogiziData
                  // Contoh:
                  // GestureDetector(
                  //   onTap: () { /* Handle sorting */ },
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         'Sort By',
                  //         style: TextStyle(fontSize: 14, color: Color(0xFF718096)),
                  //       ),
                  //       SizedBox(width: 5),
                  //       Icon(Icons.keyboard_arrow_down, color: Color(0xFF718096), size: 18),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Progress/History List (sekarang menampilkan Info Gizi)
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ),
                        )
                      : _displayedInfogiziData.isEmpty
                          ? const Center(child: Text('No nutrition data found.'))
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: _displayedInfogiziData.length,
                              itemBuilder: (context, index) {
                                final item = _displayedInfogiziData[index];
                                return _buildInfogiziItem(context, item); // Panggil fungsi baru
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function for building an Infogizi item
  Widget _buildInfogiziItem(BuildContext context, Infogizi infogizi) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail saat item diklik
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailNutrisiPage(infogizi: infogizi),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Gambar nutrisi
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  infogizi.image, // Menggunakan URL gambar dari model Infogizi
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.broken_image, color: Colors.grey[600]),
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      infogizi.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${infogizi.calories.toStringAsFixed(0)} kcal', // Tampilkan kalori
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF718096),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.egg, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${infogizi.proteins.toStringAsFixed(1)}g Protein',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.oil_barrel, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${infogizi.fat.toStringAsFixed(1)}g Fat',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Tambahkan ikon panah atau detail lainnya jika diinginkan
              const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF718096)),
            ],
          ),
        ),
      ),
    );
  }
}