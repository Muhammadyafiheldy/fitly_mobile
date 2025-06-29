import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fitly_v1/controller/my_carousel_controller.dart';

class CarouselBanner extends StatefulWidget {
  final List<String> imageUrls;
  final MyCarouselController controller;

  const CarouselBanner({
    super.key,
    required this.imageUrls,
    required this.controller,
  });

  @override
  State<CarouselBanner> createState() => _CarouselBannerState();
}

class _CarouselBannerState extends State<CarouselBanner> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: widget.controller.controller,
          items: widget.imageUrls.map((url) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(url),
            );
          }).toList(),
          options: CarouselOptions(
            height: 160,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageUrls.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? Colors.green
                    : Colors.grey.withAlpha((0.4 * 255).toInt()),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Deteksi gambar lokal atau dari URL
  Widget _buildImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.broken_image));
        },
      );
    } else {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }
  }
}
