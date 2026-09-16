import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'main_screen.dart';

void main() {
  runApp(const PersiapanNikahApp());
}

class PersiapanNikahApp extends StatelessWidget {
  const PersiapanNikahApp({super.key});

  // Fungsi untuk mengecek apakah user sudah punya sesi login
  Future<bool> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Persiapan Pernikahan',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1A120B),
        primaryColor: const Color(0xFF3C2A21),
        textTheme: GoogleFonts.philosopherTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: const Color(0xFFE5E5CB),
                displayColor: const Color(0xFFD5CEA3),
              ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // FutureBuilder akan menentukan halaman pertama berdasarkan status sesi
      home: FutureBuilder<bool>(
        future: _checkSession(),
        builder: (context, snapshot) {
          // Menunggu proses pengecekan selesai
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: Color(0xFFD5CEA3))),
            );
          }
          // Jika isLoggedIn = true, langsung ke Beranda. Jika tidak, ke Login.
          if (snapshot.data == true) {
            return const MainScreen();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}