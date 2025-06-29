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

  String? _heightError, _weightError, _ageError;
  bool _genderError = false;

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
    });
  }

  void _submit() {
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
      final tinggiM = double.parse(controller.heightController.text) / 100;
      final berat = double.parse(controller.weightController.text);
      final bmi = berat / (tinggiM * tinggiM);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HitungBmi(bmi: bmi)),
      );
    }
  }

  String? _validateNumber(String value, {bool isInt = false}) {
    if (value.isEmpty) return 'Wajib diisi';
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
                        onChanged:
                            (val) => setState(() => controller.gender = val),
                        showError: _genderError,
                      ),
                      const SizedBox(height: 16),
                      _LabeledField(
                        label: 'Usia (tahun)',
                        child: CustomTextField(
                          controller: controller.ageController,
                          errorText: _ageError,
                          keyboardType: TextInputType.number, hint: '',
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
                                keyboardType: TextInputType.number, hint: '',
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
                                keyboardType: TextInputType.number, hint: '',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: "Hitung BMI",
                              onPressed: _submit,
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
