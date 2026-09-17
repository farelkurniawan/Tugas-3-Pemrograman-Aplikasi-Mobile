import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'main_screen.dart';

/// Titik awal aplikasi Flutter.
///
/// Firebase harus selesai diinisialisasi sebelum widget aplikasi dijalankan.
/// Karena proses tersebut asynchronous, fungsi `main` menggunakan `async`
/// dan menunggu `Firebase.initializeApp` dengan `await`.
void main() async {
  // Menyiapkan binding Flutter sebelum menjalankan operasi platform/plugin.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Memakai konfigurasi hasil FlutterFire sesuai platform yang sedang dipakai.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Menjalankan root widget setelah seluruh persiapan awal selesai.
  runApp(const PersiapanNikahApp());
}

/// Root widget yang mengatur konfigurasi global aplikasi.
///
/// Widget ini menentukan tema, judul aplikasi, serta halaman awal berdasarkan
/// status login yang tersimpan di SharedPreferences.
class PersiapanNikahApp extends StatelessWidget {
  const PersiapanNikahApp({super.key});

  /// Membaca status login lokal dari SharedPreferences.
  ///
  /// `false` dipakai sebagai nilai default jika key `isLoggedIn` belum ada,
  /// sehingga pengguna baru diarahkan ke halaman login.
  Future<bool> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // MaterialApp menyediakan navigasi, tema, dan konfigurasi dasar Flutter.
    return MaterialApp(
      title: 'Aplikasi Persiapan Pernikahan',
      theme: ThemeData(
        // Cokelat gelap menjadi warna dasar aplikasi agar konsisten dengan
        // halaman fitur lain, termasuk halaman acara dan Weton.
        scaffoldBackgroundColor: const Color(0xFF1A120B),
        primaryColor: const Color(0xFF3C2A21),
        // Philosopher dipakai agar tampilan bertema pernikahan terasa lebih
        // khas; warna teks krem menjaga keterbacaan di latar gelap.
        textTheme: GoogleFonts.philosopherTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: const Color(0xFFE5E5CB),
                displayColor: const Color(0xFFD5CEA3),
              ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // FutureBuilder menunggu pengecekan sesi selesai sebelum memilih halaman
      // awal. Ini mencegah login atau beranda tampil sebelum data siap.
      home: FutureBuilder<bool>(
        future: _checkSession(),
        builder: (context, snapshot) {
          // Tampilkan indikator selama SharedPreferences masih dibaca.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: Color(0xFFD5CEA3))),
            );
          }
          // Sesi aktif membuka beranda; selain itu pengguna diarahkan ke login.
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