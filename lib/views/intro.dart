import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitly_v1/widget/background_shape.dart';
import 'package:fitly_v1/views/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _completeIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundShape(),
          Column(
            children: [
              // Page view
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged:
                      (index) => setState(() => _currentPage = index),
                  children: const [
                    _IntroSlide(
                      imagePath: 'assets/icon/intro1.png',
                      title: 'Perhitungan BMI dan Kebutuhan Gizi',
                      subtitle:
                          'Mengetahui Indeks Massa Total\n'
                          'dan kebutuhan gizi dengan mudah\n'
                          'dan praktis',
                    ),
                    _IntroSlide(
                      imagePath: 'assets/icon/intro2.png',
                      title: 'Rekomendasi Olahraga dan Diet',
                      subtitle:
                          'Memberikan rekomendasi\n'
                          'olahraga yang cocok serta diet\n'
                          'yang sehat',
                    ),
                  ],
                ),
              ),

              // Dot indicator
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 2,
                  effect: ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 3,
                    spacing: 6,
                    activeDotColor: const Color(0xFFA4DD00),
                    dotColor: Colors.grey.shade400,
                  ),
                ),
              ),

              /* ---------------- NEXT BUTTON ---------------- */
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 20),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: AnimatedOpacity(
                    opacity: _currentPage == 1 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: TextButton(
                      onPressed: _currentPage == 1 ? _completeIntro : null,
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFA4DD00),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Lanjut',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// slide komponen
class _IntroSlide extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const _IntroSlide({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 150), // Jarak dari atas
            SizedBox(
              height: 200, // Tetapkan tinggi agar stabil antar slide
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}