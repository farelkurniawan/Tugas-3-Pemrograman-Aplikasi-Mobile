import 'package:flutter/material.dart';

class KonversiWetonScreen extends StatelessWidget {
  const KonversiWetonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A120B),
      appBar: AppBar(
        title: const Text('Konversi Kalender Weton', style: TextStyle(color: Color(0xFFD5CEA3))),
        backgroundColor:const Color(0xFF3C2A21),
        iconTheme: const IconThemeData(color: Color(0xFFD5CEA3)),
      ),
      body: const Center(
        child: Text(
          'Halaman Konversi Kalender Weton',
          style: TextStyle(color: Color(0xFFE5E5CB)),
        ),
      ),
    );
  }
}