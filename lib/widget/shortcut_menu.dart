import 'package:flutter/material.dart';

class ShortcutMenu extends StatelessWidget {
  const ShortcutMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.directions_run, color: Colors.green),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.fastfood, color: Colors.green),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.local_hospital, color: Colors.green),
          onPressed: () {},
        ),
      ],
    );
  }
}
