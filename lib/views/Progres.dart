import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk TextInputFormatter jika diperlukan

class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  // Variabel state untuk menyimpan data berat badan dan target
  String _currentWeight = '85 kg'; // Default value
  String _targetWeight = '75 kg'; // Default value
  String _targetDuration = 'Not set'; // Default value

  // TextEditingControllers untuk dialog input
  final TextEditingController _currentWeightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();
  final TextEditingController _targetDurationController = TextEditingController(); // Untuk durasi target

  // Sample history data (tetap ada untuk bagian Recent Activities)
  final List<Map<String, dynamic>> progressData = [
    {
      'date': '2024-06-01',
      'activity': 'Morning Running Session',
      'duration': '30 min',
      'type': 'CARDIO',
      'status': 'COMPLETED',
      'user': 'John Smith',
      'time': '2h',
      'statusColor': const Color(0xFF4CAF50), // Green
    },
    {
      'date': '2024-06-02',
      'activity': 'Evening Cycling Workout',
      'duration': '45 min',
      'type': 'ENDURANCE',
      'status': 'IN PROGRESS',
      'user': 'Sarah Johnson',
      'time': '5h',
      'statusColor': const Color(0xFFFF9800), // Orange
    },
    {
      'date': '2024-06-03',
      'activity': 'Swimming Training',
      'duration': '25 min',
      'type': 'CARDIO',
      'status': 'SCHEDULED',
      'user': 'Mike Wilson',
      'time': '1d',
      'statusColor': const Color(0xFF2196F3), // Blue
    },
    {
      'date': '2024-06-04',
      'activity': 'Weight Training Session',
      'duration': '60 min',
      'type': 'STRENGTH',
      'status': 'COMPLETED',
      'user': 'Emma Davis',
      'time': '3h',
      'statusColor': const Color(0xFF4CAF50), // Green
    },
  ];

  @override
  void dispose() {
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    _targetDurationController.dispose();
    super.dispose();
  }

  void _showAddWeightDialog() {
    // Isi controller dengan nilai saat ini jika ada
    _currentWeightController.text = _currentWeight.replaceAll(' kg', '');
    _targetWeightController.text = _targetWeight.replaceAll(' kg', '');
    _targetDurationController.text = _targetDuration == 'Not set' ? '' : _targetDuration;


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Input Weight & Target'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _currentWeightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Current Weight (kg)',
                    hintText: 'e.g., 85',
                  ),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _targetWeightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Target Weight (kg)',
                    hintText: 'e.g., 75',
                  ),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _targetDurationController,
                  keyboardType: TextInputType.text, // Bisa text untuk "3 bulan", "6 minggu", dll.
                  decoration: const InputDecoration(
                    labelText: 'Target Duration (e.g., 3 months)',
                    hintText: 'e.g., 3 months, 6 weeks',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                final String current = _currentWeightController.text;
                final String target = _targetWeightController.text;
                final String duration = _targetDurationController.text;

                if (current.isNotEmpty && target.isNotEmpty && duration.isNotEmpty) {
                  setState(() {
                    _currentWeight = '$current kg';
                    _targetWeight = '$target kg';
                    _targetDuration = duration;
                  });
                  Navigator.of(context).pop();
                } else {
                  // Tampilkan pesan error jika input kosong
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4CAF50), // Green
                    Color(0xFF2E7D32), // Darker Green
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  // Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 24,
                      ),
                      const Text(
                        'My Progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Wrap the Icon with an IconButton or GestureDetector
                      GestureDetector( // Menggunakan GestureDetector untuk menangani tap
                        onTap: _showAddWeightDialog, // Panggil fungsi dialog saat ikon diklik
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Stats Cards
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Menampilkan data dari variabel state
                        _buildStatItem(_currentWeight, 'Current Weight'),
                        _buildStatItem(_targetWeight, 'Target Weight'),
                        _buildStatItem(_targetDuration, 'Target Duration'), // Tambahkan ini
                      ],
                    ),
                  ),
                ],
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
                    'Recent Activities',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Sort By',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF718096),
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF718096),
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Progress/History List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: progressData.length,
                itemBuilder: (context, index) {
                  final item = progressData[index];
                  return _buildProgressItem(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi helper untuk item statistik
  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF718096),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Fungsi helper untuk item progres/aktivitas
  Widget _buildProgressItem(Map<String, dynamic> item) {
    return Container(
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
            // Colored left border
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: item['statusColor'],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status and Type
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7FAFC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item['type'],
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF718096),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: item['statusColor'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item['status'],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: item['statusColor'],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Activity Title
                    Text(
                      item['activity'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // User and Time
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: const Color(0xFF718096),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item['user'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF718096),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          item['time'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF718096),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}