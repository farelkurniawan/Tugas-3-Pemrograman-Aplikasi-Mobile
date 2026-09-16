import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';

class BantuanScreen extends StatelessWidget {
  const BantuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bantuan & Logout',
          style: GoogleFonts.philosopher(
            color: const Color(0xFFD5CEA3),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF3C2A21),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cara Penggunaan Aplikasi:',
              style: GoogleFonts.philosopher(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD5CEA3),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildHelpItem(
                      '1. Halaman Utama', 'Berisi 5 menu utama sesuai dengan kriteria tugas: Daftar Anggota, Komputasi Weton, CRUD Acara, Konversi Umur/Hijriah, dan Konversi Kalender Saka.'),
                  _buildHelpItem(
                      '2. Fitur Stopwatch', 'Gunakan menu tab di bawah (tengah) untuk membuka fitur Stopwatch.'),
                  _buildHelpItem(
                      '3. Cara Menggunakan Menu', 'Ketuk salah satu kartu menu di halaman utama untuk membuka fitur yang diinginkan. Anda dapat kembali menggunakan tombol back di pojok kiri atas.'),
                  _buildHelpItem(
                      '4. Keluar (Logout)', 'Gunakan tombol berwarna merah di bagian bawah halaman ini untuk keluar dari sesi (session) saat ini.'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // TOMBOL LOGOUT 
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Logika Session Logout: Menghapus riwayat halaman dan kembali ke Login
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: Text(
                  'LOGOUT SESI',
                  style: GoogleFonts.philosopher(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800], 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget tambahan biar rapi bikin list cara penggunaan
  Widget _buildHelpItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFFE5E5CB),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}