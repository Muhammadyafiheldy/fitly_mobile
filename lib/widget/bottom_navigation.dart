import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: onTap,
      selectedItemColor: const Color(0xFFA4DD00),
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.assignment_outlined),
          activeIcon: const Icon(Icons.assignment),
          label: 'Info',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.history_outlined),
          activeIcon: const Icon(Icons.history),
          label: 'Riwayat',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline),
          activeIcon: const Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}
