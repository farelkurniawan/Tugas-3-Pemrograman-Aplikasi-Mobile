import 'package:flutter/material.dart';

class DaftarAnggotaScreen extends StatelessWidget {
  const DaftarAnggotaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3C2A21),
      appBar: AppBar(
        title: const Text(
          'Daftar Anggota',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Color(0xFFD5CEA3),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Muhammad Alfarel Yudan Kurniawan'),
              subtitle: Text('124240163'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Azizah Mualifah'),
              subtitle: Text('124240165'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Agnaita Naswa Fadilla'),
              subtitle: Text('124240166'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Naila Faiza Ramadani'),
              subtitle: Text('124240177'),
            ),
          ),
        ],
      ),
    );
  }
}