import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fitly_v1/models/bmi.dart'; 
import 'package:fitly_v1/views/hitung_bmi.dart'; 
import 'package:fitly_v1/service/api_service.dart'; 

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<BmiRecord> _bmiHistoryData = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedSortOption = 'latest'; 

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

  // --- FUNGSI UNTUK MENGHAPUS BMI RECORD ---
  Future<void> _deleteBmiRecord(dynamic recordId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Pastikan recordId dikonversi ke String sebelum dikirim ke ApiService
      await ApiService.deleteBmiRecord(recordId.toString());

      setState(() {
        // Hapus item dari daftar lokal setelah sukses dihapus dari API
        _bmiHistoryData.removeWhere((record) => record.id.toString() == recordId.toString());
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('BMI record deleted successfully!')),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to delete BMI record: ${e.toString()}';
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting BMI record: ${e.toString()}')),
      );
      print('Error deleting BMI record: $e'); // For debugging
    }
  }
  // --- AKHIR FUNGSI DELETE ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 20,
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
                  child: const Row(
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

          // BMI History List
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
      // --- PERUBAHAN UTAMA DI SINI: MENAMBAHKAN onLongPress ---
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Delete BMI Record'),
              content: const Text('Are you sure you want to delete this BMI record?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss the dialog
                  },
                ),
                TextButton(
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss the dialog
                    // --- BARIS YANG DIPERBAIKI ---
                    _deleteBmiRecord(item.id.toString()); // Konversi item.id ke String
                    // --- AKHIR BARIS YANG DIPERBAIKI ---
                  },
                ),
              ],
            );
          },
        );
      },
      // --- AKHIR PERUBAHAN UTAMA ---
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
                      const Text(
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