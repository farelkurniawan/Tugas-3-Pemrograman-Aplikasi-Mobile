import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';

void main() {
  runApp(const PersiapanNikahApp());
}

class PersiapanNikahApp extends StatelessWidget {
  const PersiapanNikahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Persiapan Pernikahan',
      theme: ThemeData(
        // Warna dasar background (Hitam Kecoklatan)
        scaffoldBackgroundColor: const Color(0xFF1A120B),
        // Warna utama aplikasi
        primaryColor: const Color(0xFF3C2A21),
        // Menerapkan font Philosopher ke seluruh aplikasi
        textTheme: GoogleFonts.philosopherTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: const Color(0xFFE5E5CB), // Warna teks krem
                displayColor: const Color(0xFFD5CEA3), // Warna judul emas
              ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}