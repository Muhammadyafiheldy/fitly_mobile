import 'package:flutter/material.dart';
import 'home.dart';
import 'info.dart';
import 'history.dart';
import 'profile.dart';
import '../widget/bottom_navigation.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    InfoPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
