import 'package:flutter/material.dart';
class DaftarAnggotaScreen extends StatelessWidget {
  const DaftarAnggotaScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3C2A21),
      appBar: AppBar(title: const Text('Daftar Anggota', style: TextStyle(color: Colors.white)), backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.greenAccent)),
      body: const Center(child: Text('Halaman Daftar Anggota', style: TextStyle(color: Colors.white))),
    );
  }
}