import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample history data with different activity types and statuses
    final List<Map<String, dynamic>> historyData = [
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
                      const Icon(Icons.menu, color: Colors.white, size: 24),
                      const Text(
                        'Activity History',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(Icons.add, color: Colors.white, size: 24),
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
                        _buildStatItem('85', 'Berat badan saat ini '),

                        _buildStatItem('75', 'Target berat badan'),
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
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: const Color(0xFF718096),
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // History List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: historyData.length,
                itemBuilder: (context, index) {
                  final item = historyData[index];
                  return _buildHistoryItem(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildHistoryItem(Map<String, dynamic> item) {
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
