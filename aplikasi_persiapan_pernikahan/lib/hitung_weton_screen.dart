import 'package:flutter/material.dart';
class HitungWetonScreen extends StatelessWidget {
  const HitungWetonScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3C2A21),
      appBar: AppBar(title: const Text('Hitung Kecocokan Weton', style: TextStyle(color: Colors.white)), backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.greenAccent)),
      body: const Center(child: Text('Halaman Hitung Weton', style: TextStyle(color: Colors.white))),
    );
  }
}