import 'package:flutter/material.dart';
import 'beranda_screen.dart';
import 'stopwatch_screen.dart';
import 'bantuan_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const BerandaScreen(),
    const StopwatchScreen(),
    const BantuanScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF3C2A21), // Coklat
          selectedItemColor: const Color(0xFFD5CEA3), // Emas
          unselectedItemColor: Colors.white54,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Beranda'),
            BottomNavigationBarItem(icon: Icon(Icons.timer_outlined), label: 'Stopwatch'),
            BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Bantuan'),
          ],
        ),
      ),
    );
  }
}