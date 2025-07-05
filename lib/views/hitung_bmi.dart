import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HitungBmi extends StatefulWidget {
  final double bmi;
  final double bmr;
  final double tdee;
  final String activity;

  const HitungBmi({
    super.key,
    required this.bmi,
    required this.bmr,
    required this.tdee,
    required this.activity,
  });

  @override
  State<HitungBmi> createState() => _HitungBmiState();
}

class _HitungBmiState extends State<HitungBmi> {
  String _getCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    if (bmi < 40) return 'Obese';
    return 'Severely Obese';
  }

  Color _getCategoryColor(double bmi) {
    if (bmi < 18.5) return Colors.lightBlue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.yellow;
    if (bmi < 40) return Colors.orange;
    return Colors.red;
  }

  Widget _buildGaugeCard() {
    final double bmiValue = widget.bmi.clamp(10.0, 50.0);
    final categoryColor = _getCategoryColor(widget.bmi);
    final categoryText = _getCategory(widget.bmi);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Column(
          children: [
            const Text(
              'Indeks Massa Tubuh (BMI)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 260,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    startAngle: 180,
                    endAngle: 0,
                    minimum: 10,
                    maximum: 50,
                    showTicks: false,
                    showLabels: false,
                    canScaleToFit: true,
                    axisLineStyle: const AxisLineStyle(
                      thickness: 10,
                      thicknessUnit: GaugeSizeUnit.logicalPixel,
                    ),
                    ranges: <GaugeRange>[
                      GaugeRange(
                        startValue: 10,
                        endValue: 18.5,
                        color: Colors.lightBlue,
                        startWidth: 50,
                        endWidth: 50,
                      ),
                      GaugeRange(
                        startValue: 18.5,
                        endValue: 24.9,
                        color: Colors.green,
                        startWidth: 50,
                        endWidth: 50,
                      ),
                      GaugeRange(
                        startValue: 25,
                        endValue: 29.9,
                        color: Colors.yellow,
                        startWidth: 50,
                        endWidth: 50,
                      ),
                      GaugeRange(
                        startValue: 30,
                        endValue: 39.9,
                        color: Colors.orange,
                        startWidth: 50,
                        endWidth: 50,
                      ),
                      GaugeRange(
                        startValue: 40,
                        endValue: 50,
                        color: Colors.red,
                        startWidth: 50,
                        endWidth: 50,
                      ),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        value: bmiValue,
                        enableAnimation: true,
                        animationType: AnimationType.ease,
                        needleColor: Colors.black,
                        knobStyle: const KnobStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'BMI Anda: ${widget.bmi.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _getCategory(widget.bmi),
              style: TextStyle(
                fontSize: 16,
                color: categoryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBmrCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.local_fire_department, color: Colors.redAccent),
                SizedBox(width: 8),
                Text(
                  'BMR (Basal Metabolic Rate)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                '${widget.bmr.toStringAsFixed(0)} kalori/hari',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.bolt, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  'TDEE (Total Kebutuhan Kalori)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '${widget.tdee.toStringAsFixed(0)} kalori/hari',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Aktivitas: ${widget.activity}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil BMI & BMR')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildGaugeCard(), // BMI Gauge + nilai BMI
            const SizedBox(height: 12),
            _buildBmrCard(), // BMR + TDEE + aktivitas
          ],
        ),
      ),
    );
  }
}
