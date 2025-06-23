import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';

class MyCarouselController {
  final CarouselSliderController controller = CarouselSliderController();

  void goToPage(int pageIndex) {
    controller.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }
}