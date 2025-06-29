import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HitungBmi extends StatefulWidget {
  final double bmi; // Nilai BMI dari halaman sebelumnya

  const HitungBmi({super.key, required this.bmi});

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

  Widget _getRadialGauge() {
    final double bmiValue = widget.bmi.clamp(10.0, 50.0);

    return SfRadialGauge(
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
            thickness: 10, // ✅ Buat gauge-nya lebih tebal
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
              needleColor: Colors.black,
              knobStyle: const KnobStyle(color: Colors.black),
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              angle: 90,
              positionFactor: 0.8,
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.bmi.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getCategory(widget.bmi),
                    style: TextStyle(
                      fontSize: 16,
                      color: _getCategoryColor(widget.bmi),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil BMI')),
      body: Center(child: _getRadialGauge()),
    );
  }
}
