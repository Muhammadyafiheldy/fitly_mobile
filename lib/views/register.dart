import 'package:fitly_v1/controller/register_controller.dart';
import 'package:fitly_v1/views/home.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final controller = RegisterController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF0),
      body: Stack(
        children: [
          const BackgroundShape(),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 150),
                const Text(
                  'Daftar Akun',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),

                // Nama
                Container(
                  decoration: _inputShadow(),
                  child: TextField(
                    controller: controller.nameController,
                    decoration: _inputDecoration('Masukkan Nama'),
                  ),
                ),
                const SizedBox(height: 16),

                // Email
                Container(
                  decoration: _inputShadow(),
                  child: TextField(
                    controller: controller.emailController,
                    decoration: _inputDecoration(
                      'Masukkan email',
                    ).copyWith(errorText: controller.emailError),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                Container(
                  decoration: _inputShadow(),
                  child: TextField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible,
                    decoration: _inputDecoration(
                      'Masukkan kata sandi',
                    ).copyWith(
                      errorText: controller.passwordError,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            controller.togglePasswordVisibility((visible) {});
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol Daftar
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (controller.validateInputs()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Registrasi berhasil"),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA4DD00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Daftar',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  BoxDecoration _inputShadow() {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
      ],
    );
  }
}

// Background curve
class BackgroundShape extends StatelessWidget {
  const BackgroundShape({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: ShapePainter(), child: Container());
  }
}

class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final topPaint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFF6BCB77), Color(0xFFA4DD00)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, 0, size.width, 200));

    final bottomPaint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFFA4DD00), Color(0xFF6BCB77)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, size.height - 200, size.width, 200));

    final topPath =
        Path()
          ..lineTo(0, 120)
          ..quadraticBezierTo(size.width * 0.25, 80, size.width * 0.5, 110)
          ..quadraticBezierTo(size.width * 0.75, 140, size.width, 100)
          ..lineTo(size.width, 0)
          ..close();
    canvas.drawPath(topPath, topPaint);

    final bottomPath =
        Path()
          ..moveTo(0, size.height)
          ..lineTo(0, size.height - 100)
          ..quadraticBezierTo(
            size.width * 0.5,
            size.height - 20,
            size.width,
            size.height - 100,
          )
          ..lineTo(size.width, size.height)
          ..close();
    canvas.drawPath(bottomPath, bottomPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
