import 'package:flutter/material.dart';
class KonversiSakaBaliScreen extends StatelessWidget {
  const KonversiSakaBaliScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3C2A21),
      appBar: AppBar(title: const Text('Konversi Saka Bali', style: TextStyle(color: Colors.white)), backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.greenAccent)),
      body: const Center(child: Text('Halaman Konversi Saka Bali', style: TextStyle(color: Colors.white))),
    );
  }
}