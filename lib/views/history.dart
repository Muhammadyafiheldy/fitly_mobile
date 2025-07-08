// lib/pages/history_page.dart (BAGIAN YANG DIUBAH)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import untuk format tanggal
import 'package:fitly_v1/models/bmi.dart'; // Import model BmiRecord
import 'package:fitly_v1/views/hitung_bmi.dart'; // Import halaman HitungBmi
import 'package:fitly_v1/service/api_service.dart'; // Import ApiService

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<BmiRecord> _bmiHistoryData = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedSortOption = 'latest'; // Default: terbaru ('latest' or 'oldest')

  @override
  void initState() {
    super.initState();
    _fetchBmiHistory();
  }

  Future<void> _fetchBmiHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final fetchedRecords = await ApiService.fetchBmiRecords();
      setState(() {
        _bmiHistoryData = fetchedRecords;
        _sortBmiHistory(); // Urutkan setelah data diambil
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load BMI history: ${e.toString()}';
        _isLoading = false;
      });
      print('Error fetching BMI records: $e'); // For debugging
    }
  }

  void _sortBmiHistory() {
    setState(() {
      if (_selectedSortOption == 'latest') {
        _bmiHistoryData.sort((a, b) => b.recordedAt.compareTo(a.recordedAt)); // Terbaru ke terlama
      } else if (_selectedSortOption == 'oldest') {
        _bmiHistoryData.sort((a, b) => a.recordedAt.compareTo(b.recordedAt)); // Terlama ke terbaru
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      // --- PERUBAHAN UTAMA DI SINI ---
      body: Column( // Langsung gunakan Column tanpa SafeArea di level ini
        children: [
          // Header (Sekarang tidak dalam SafeArea)
          Container(
            width: double.infinity,
            // Anda bisa menggunakan MediaQuery.of(context).padding.top
            // untuk menambahkan padding secara manual untuk status bar
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20, // Padding atas untuk status bar + ruang
              bottom: 20, // Padding bawah
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFA4DD00),
                  Color(0xFF6BCB77),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Activity History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // --- AKHIR PERUBAHAN UTAMA ---

          const SizedBox(height: 20),

          // Section Header: Recent Activities with Sort By
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Activities',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                PopupMenuButton<String>(
                  initialValue: _selectedSortOption,
                  onSelected: (String newValue) {
                    setState(() {
                      _selectedSortOption = newValue;
                      _sortBmiHistory(); // Urutkan ulang saat opsi berubah
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'latest',
                      child: Text('Latest'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'oldest',
                      child: Text('Oldest'),
                    ),
                  ],
                  child: const Row( // Ditambahkan const
                    children: [
                      Text(
                        'Sort By',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF718096),
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF718096),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // BMI History List (Sekarang bagian ini dalam Expanded yang tetap di dalam Column)
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red, fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _fetchBmiHistory,
                                child: const Text('Try Again'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _bmiHistoryData.isEmpty
                        ? const Center(
                            child: Text(
                              'No BMI records found.',
                              style: TextStyle(fontSize: 16, color: Color(0xFF718096)),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _bmiHistoryData.length,
                            itemBuilder: (context, index) {
                              final bmiItem = _bmiHistoryData[index];
                              return _buildBmiHistoryItem(context, bmiItem);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'underweight':
        return Colors.lightBlue;
      case 'normal':
        return Colors.green;
      case 'overweight':
        return Colors.yellow.shade800;
      case 'obese':
        return Colors.orange;
      case 'severely obese':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildBmiHistoryItem(BuildContext context, BmiRecord item) {
    final Color categoryColor = _getCategoryColor(item.category);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HitungBmi(
              bmi: item.bmi,
              bmr: item.bmr,
              tdee: item.tdee,
              activity: item.activityLevel,
            ),
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
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: categoryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text( // Ditambahkan const
                        'BMI Calculation',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'BMI: ${item.bmi.toStringAsFixed(2)} - ${item.category}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: categoryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Height: ${item.height.toStringAsFixed(0)} cm, Weight: ${item.weight.toStringAsFixed(0)} kg',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF718096),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd MMMM yyyy, HH:mm').format(item.recordedAt), // Menambahkan tahun (yyyy)
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}