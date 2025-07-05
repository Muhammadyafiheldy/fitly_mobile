
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pastikan ini diimport jika masih digunakan
import '../widget/custom_text_field.dart';
import '../widget/primary_button.dart';
import '../controller/bmi_controller.dart';
import 'hitung_bmi.dart';
import '../service/api_service.dart'; // <--- Tambahkan import ini
import 'package:http/http.dart' as http; // Pastikan http client diimport jika belum

class BmiPage extends StatefulWidget {
  const BmiPage({Key? key}) : super(key: key);

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  final _formKey = GlobalKey<FormState>();
  final BmiController controller = BmiController();

  String? _heightError, _weightError, _ageError;
  bool _genderError = false;

  // --- input tambahan untuk BMR/TDEE ---
  String _activityLevel = 'Sedentary';
  final Map<String, double> _activityFactor = {
    'Sedentary': 1.2,
    'Ringan': 1.375,
    'Sedang': 1.55,
    'Berat': 1.725,
    'Sangat Berat': 1.9,
  };

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      controller.reset();
      _heightError = _weightError = _ageError = null;
      _genderError = false;
      _activityLevel = 'Sedentary';
    });
  }

  // Mengubah _submit menjadi async karena akan ada operasi jaringan
  Future<void> _submit() async {
    setState(() {
      _heightError = _validateNumber(controller.heightController.text);
      _weightError = _validateNumber(controller.weightController.text);
      _ageError = _validateNumber(controller.ageController.text, isInt: true);
      _genderError = controller.gender == null;
    });

    if (_heightError == null &&
        _weightError == null &&
        _ageError == null &&
        !_genderError) {
      final tinggiCm = double.parse(controller.heightController.text); // Tinggi dalam CM untuk perhitungan BMR
      final tinggiM = tinggiCm / 100; // Tinggi dalam Meter untuk perhitungan BMI
      final berat = double.parse(controller.weightController.text);
      final usia = int.parse(controller.ageController.text);
      final gender = controller.gender!;

      // ---- HITUNG BMI ----
      final bmi = berat / (tinggiM * tinggiM);

      // ---- HITUNG BMR (Harris-Benedict - Konsisten dengan Backend) ----
      final bmr = (gender == 'Laki-laki')
          ? 88.36 + (13.4 * berat) + (4.8 * tinggiCm) - (5.7 * usia)
          : 447.6 + (9.2 * berat) + (3.1 * tinggiCm) - (4.3 * usia);

      final tdee = bmr * _activityFactor[_activityLevel]!;

      // ---- SIMPAN DATA KE DATABASE MELALUI API ----
      try {
        await ApiService.saveBmiData(
          height: tinggiCm, // Kirim tinggi dalam CM
          weight: berat,
          age: usia,
          gender: gender,
          activityLevel: _activityLevel,
          bmi: bmi, // Kirim BMI yang sudah dihitung
          bmr: bmr, // Kirim BMR yang sudah dihitung
          tdee: tdee, // Kirim TDEE yang sudah dihitung
        );

        // Jika berhasil disimpan, lanjutkan ke halaman hasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HitungBmi(
              bmi: bmi,
              bmr: bmr,
              tdee: tdee,
              activity: _activityLevel,
            ),
          ),
        );
      } catch (e) {
        // Tampilkan error jika gagal menyimpan
        print('Error saving BMI data: $e'); // Log error untuk debugging
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String? _validateNumber(String value, {bool isInt = false}) {
    if (value.isEmpty) return 'Wajib diisi';
    // Menambahkan pengecekan untuk angka positif
    if (double.tryParse(value) != null && double.parse(value) <= 0) {
      return 'Harus lebih dari 0';
    }
    return isInt
        ? int.tryParse(value) == null
            ? 'Hanya angka'
            : null
        : double.tryParse(value) == null
            ? 'Hanya angka'
            : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Indeks Masa Tubuh',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA4DD00), Color(0xFF6BCB77)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Lengkapi Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _GenderRadio(
                        value: controller.gender,
                        onChanged: (val) =>
                            setState(() => controller.gender = val),
                        showError: _genderError,
                      ),
                      const SizedBox(height: 16),
                      _LabeledField(
                        label: 'Usia (tahun)',
                        child: CustomTextField(
                          controller: controller.ageController,
                          errorText: _ageError,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Hanya izinkan angka bulat
                          hint: '',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _LabeledField(
                              label: 'Tinggi Badan (cm)',
                              child: CustomTextField(
                                controller: controller.heightController,
                                errorText: _heightError,
                                keyboardType: TextInputType.number,
                                hint: '',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _LabeledField(
                              label: 'Berat Badan (kg)',
                              child: CustomTextField(
                                controller: controller.weightController,
                                errorText: _weightError,
                                keyboardType: TextInputType.number,
                                hint: '',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /* ---------- Dropdown Aktivitas ---------- */
                      _LabeledField(
                        label: 'Tingkat Aktivitas',
                        child: DropdownButtonFormField<String>(
                          value: _activityLevel,
                          items: _activityFactor.keys
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e == 'Sedentary'
                                        ? 'Sedentary (tidak aktif)'
                                        : e,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _activityLevel = v!),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: "Hitung BMI & BMR",
                              onPressed: _submit, // Panggil _submit yang sudah async
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _resetForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEAEAEA),
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Reset',
                                style: TextStyle(
                                  color: Color(0xFF919191),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- Widget Bantu ---------------- */

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;

  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFBDBDBD),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _GenderRadio extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool showError;

  const _GenderRadio({
    required this.value,
    required this.onChanged,
    required this.showError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jenis Kelamin',
          style: TextStyle(
            color: Color(0xFFBDBDBD),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                value: 'Laki-laki',
                groupValue: value,
                onChanged: onChanged,
                title: const Text('Laki-laki'),
                activeColor: Color(0xFFA4DD00),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                value: 'Perempuan',
                groupValue: value,
                onChanged: onChanged,
                title: const Text('Perempuan'),
                activeColor: Color(0xFFA4DD00),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
          ],
        ),
        if (showError)
          const Padding(
            padding: EdgeInsets.only(left: 4, top: 4),
            child: Text(
              'Wajib pilih salah satu',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}