import 'package:flutter/material.dart';
import '../widget/custom_text_field.dart';
import '../widget/primary_button.dart';
import '../controller/bmi_controller.dart';
import 'hitung_bmi.dart';

class BmiPage extends StatefulWidget {
  const BmiPage({Key? key}) : super(key: key);

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  final _formKey = GlobalKey<FormState>();
  final BmiController controller = BmiController();

  String? _heightError;
  String? _weightError;
  String? _ageError;
  bool _genderError = false;

  /* ---------------- LIFECYCLE ---------------- */
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /* ---------------- RESET FORM ---------------- */
  void _resetForm() {
    setState(() {
      controller.reset();
      _heightError = null;
      _weightError = null;
      _ageError = null;
      _genderError = false;
    });
  }

  /* ---------------- SUBMIT / HITUNG BMI ---------------- */
  void _submit() {
    setState(() {
      /* --- VALIDASI INPUT --- */
      _heightError =
          controller.heightController.text.isEmpty
              ? 'Wajib diisi'
              : double.tryParse(controller.heightController.text) == null
              ? 'Hanya angka'
              : null;

      _weightError =
          controller.weightController.text.isEmpty
              ? 'Wajib diisi'
              : double.tryParse(controller.weightController.text) == null
              ? 'Hanya angka'
              : null;

      _ageError =
          controller.ageController.text.isEmpty
              ? 'Wajib diisi'
              : int.tryParse(controller.ageController.text) == null
              ? 'Hanya angka'
              : null;

      _genderError = controller.gender == null;
    });

    /* --- JIKA VALID --- */
    if (_heightError == null &&
        _weightError == null &&
        _ageError == null &&
        !_genderError) {
      final double tinggiCm = double.parse(controller.heightController.text);
      final double beratKg = double.parse(controller.weightController.text);
      final double tinggiM = tinggiCm / 100;
      final double bmi = beratKg / (tinggiM * tinggiM);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HitungBmi(bmi: bmi)),
      );
    }
  }

  /* ---------------- UI ---------------- */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Indeks Masa Tubuh',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA4DD00), Color(0xFF6BCB77)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Lengkapi Data',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /* ---------- Jenis Kelamin ---------- */
                      _GenderRadio(
                        value: controller.gender,
                        onChanged:
                            (val) => setState(() => controller.gender = val),
                        showError: _genderError,
                      ),
                      const SizedBox(height: 16),

                      /* ---------- Usia ---------- */
                      _LabeledField(
                        label: 'Usia (tahun)',
                        child: CustomTextField(
                          controller: controller.ageController,
                          hint: '',
                          errorText: _ageError,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(height: 16),

                      /* ---------- Tinggi & Berat ---------- */
                      Row(
                        children: [
                          Expanded(
                            child: _LabeledField(
                              label: 'Tinggi Badan (cm)',
                              child: CustomTextField(
                                controller: controller.heightController,
                                hint: '',
                                errorText: _heightError,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _LabeledField(
                              label: 'Berat Badan (kg)',
                              child: CustomTextField(
                                controller: controller.weightController,
                                hint: '',
                                errorText: _weightError,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      /* ---------- Tombol ---------- */
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: "Hitung BMI",
                              onPressed: _submit, // ← di sini
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
