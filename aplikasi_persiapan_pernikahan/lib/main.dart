import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const PersiapanNikahApp());
}

class PersiapanNikahApp extends StatelessWidget {
  const PersiapanNikahApp({super.key});

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
      home: FutureBuilder<bool>(
        future: _checkSession(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: Color(0xFFD5CEA3))),
            );
          }
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