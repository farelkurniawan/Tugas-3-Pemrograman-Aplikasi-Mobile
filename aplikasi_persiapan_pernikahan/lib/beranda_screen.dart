import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'daftar_anggota_screen.dart';
import 'hitung_weton_screen.dart';
import 'acara_penting_screen.dart';
import 'konversi_hijriah_screen.dart';
import 'konversi_umur_screen.dart'; 
import 'konversi_weton_screen.dart'; 
import 'konversi_saka_bali_screen.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Daftar Anggota Kelompok', 'icon': Icons.people_alt_outlined, 'page': const DaftarAnggotaScreen()},
      {'title': 'Komputasi: Kecocokan Weton', 'icon': Icons.balance, 'page': const HitungWetonScreen()},
      {'title': 'CRUD: Kelola Acara Penting', 'icon': Icons.event_note_outlined, 'page': const AcaraPentingScreen()},
      {'title': 'Konversi Tanggal Hijriah', 'icon': Icons.dark_mode_outlined, 'page': const KonversiHijriahScreen()},
      {'title': 'Konversi Tanggal Lahir ke Umur', 'icon': Icons.cake_outlined, 'page': const KonversiUmurScreen()},
      {'title': 'Konversi Kalender Weton', 'icon': Icons.date_range_outlined, 'page': const KonversiWetonScreen()},
      {'title': 'Konversi Kalender Saka Bali', 'icon': Icons.brightness_5_outlined, 'page': const KonversiSakaBaliScreen()},
    ];

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                  const SizedBox(height: 20),
                  
                  Text(
                    'Persiapan Pernikahan',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.philosopher(
                      color: const Color(0xFFD5CEA3),
                      fontSize: 32, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // LIST MENU 7 ITEM
                  ListView.builder(
                    shrinkWrap: true, 
                    physics: const NeverScrollableScrollPhysics(), 
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color(0xFF2C1E16), 
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: const Color(0xFFD5CEA3).withOpacity(0.2), width: 1),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          splashColor: const Color(0xFFD5CEA3).withOpacity(0.3),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => menuItems[index]['page']),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center, 
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3C2A21),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    menuItems[index]['icon'],
                                    color: const Color(0xFFD5CEA3),
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    menuItems[index]['title'],
                                    textAlign: TextAlign.center, 
                                    style: const TextStyle(
                                      fontSize: 15, 
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFE5E5CB),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white38,
                                  size: 16,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}