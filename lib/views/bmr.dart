import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BmrApp extends StatelessWidget {
  const BmrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator BMR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const BmrPage(),
    );
  }
}

class BmrPage extends StatefulWidget {
  const BmrPage({super.key});

  @override
  State<BmrPage> createState() => _BmrPageState();
}

class _BmrPageState extends State<BmrPage> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();

  String _gender = 'Pria';
  double? _bmrResult;
  String _activityLevel = 'Sedentary';

  final Map<String, double> _activityMultipliers = {
    'Sedentary': 1.2,
    'Ringan': 1.375,
    'Sedang': 1.55,
    'Berat': 1.725,
    'Sangat Berat': 1.9,
  };

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _calculateBMR() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final weight = double.parse(_weightController.text);
    final height = double.parse(_heightController.text);
    final age = int.parse(_ageController.text);

    double bmr = 0;
    if (_gender == 'Pria') {
      bmr = 88.36 + (13.4 * weight) + (4.8 * height) - (5.7 * age);
    } else {
      bmr = 447.6 + (9.2 * weight) + (3.1 * height) - (4.3 * age);
    }

    setState(() {
      _bmrResult = bmr;
    });
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _weightController.clear();
    _heightController.clear();
    _ageController.clear();
    setState(() {
      _gender = 'Pria';
      _activityLevel = 'Sedentary';
      _bmrResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator BMR'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi Pribadi',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _gender,
                        decoration: const InputDecoration(
                          labelText: 'Jenis Kelamin',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Pria', child: Text('Pria')),
                          DropdownMenuItem(
                            value: 'Wanita',
                            child: Text('Wanita'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pilih jenis kelamin';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _weightController,
                        decoration: const InputDecoration(
                          labelText: 'Berat Badan (kg)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.monitor_weight),
                          suffixText: 'kg',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan berat badan';
                          }
                          final weight = double.tryParse(value);
                          if (weight == null || weight <= 0 || weight > 500) {
                            return 'Masukkan berat badan yang valid (1-500 kg)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _heightController,
                        decoration: const InputDecoration(
                          labelText: 'Tinggi Badan (cm)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.height),
                          suffixText: 'cm',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan tinggi badan';
                          }
                          final height = double.tryParse(value);
                          if (height == null || height <= 0 || height > 300) {
                            return 'Masukkan tinggi badan yang valid (1-300 cm)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _ageController,
                        decoration: const InputDecoration(
                          labelText: 'Usia (tahun)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.cake),
                          suffixText: 'tahun',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan usia';
                          }
                          final age = int.tryParse(value);
                          if (age == null || age <= 0 || age > 120) {
                            return 'Masukkan usia yang valid (1-120 tahun)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _activityLevel,
                        decoration: const InputDecoration(
                          labelText: 'Tingkat Aktivitas',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.fitness_center),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Sedentary',
                            child: Text('Sedentary (Tidak aktif)'),
                          ),
                          DropdownMenuItem(
                            value: 'Ringan',
                            child: Text('Ringan (1-3 hari/minggu)'),
                          ),
                          DropdownMenuItem(
                            value: 'Sedang',
                            child: Text('Sedang (3-5 hari/minggu)'),
                          ),
                          DropdownMenuItem(
                            value: 'Berat',
                            child: Text('Berat (6-7 hari/minggu)'),
                          ),
                          DropdownMenuItem(
                            value: 'Sangat Berat',
                            child: Text('Sangat Berat (2x sehari)'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _activityLevel = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _calculateBMR,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Hitung BMR'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _resetForm,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_bmrResult != null) ...[
                Card(
                  elevation: 4,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Hasil Perhitungan BMR',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_bmrResult!.toStringAsFixed(0)} kalori/hari',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        Text(
                          'Kebutuhan Kalori Harian (TDEE)',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${(_bmrResult! * _activityMultipliers[_activityLevel]!).toStringAsFixed(0)} kalori/hari',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Berdasarkan tingkat aktivitas: $_activityLevel',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi BMR',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'BMR (Basal Metabolic Rate) adalah jumlah kalori yang dibutuhkan tubuh untuk menjalankan fungsi dasar seperti bernapas, sirkulasi darah, dan metabolisme sel saat istirahat total.',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'TDEE (Total Daily Energy Expenditure) adalah total kalori yang Anda butuhkan per hari termasuk aktivitas fisik.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
