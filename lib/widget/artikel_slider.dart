import 'package:flutter/material.dart';

class ArtikelSlider extends StatelessWidget {
  const ArtikelSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(5, (index) {
          return Container(
            width: 200,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.lightGreen[100 * ((index % 8) + 1)],
            child: Center(child: Text("Artikel ${index + 1}")),
          );
        }),
      ),
    );
  }
}
