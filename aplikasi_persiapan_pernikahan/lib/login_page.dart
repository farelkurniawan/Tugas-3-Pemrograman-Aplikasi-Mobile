import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: const Color(0xFF3C2A21), // Coklat wayang
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.diversity_1, size: 60, color: const Color(0xFFD5CEA3)),
                  const SizedBox(height: 16),
                  Text(
                    'Pintu Gerbang',
                    style: GoogleFonts.philosopher(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD5CEA3),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Persiapan Pernikahan',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                  ),
                  const SizedBox(height: 40),
                  
                  // Form Username
                  TextField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1A120B),
                      hintText: 'Nama Pengguna',
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(Icons.person_outline, color: Color(0xFFD5CEA3)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Form Password
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1A120B),
                      hintText: 'Kata Sandi',
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFD5CEA3)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Tombol Login
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD5CEA3), // Emas
                        foregroundColor: const Color(0xFF1A120B), // Teks hitam
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'MASUK',
                        style: GoogleFonts.philosopher(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}