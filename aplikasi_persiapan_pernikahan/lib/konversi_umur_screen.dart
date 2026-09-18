import 'package:flutter/material.dart';

class KonversiUmurScreen extends StatefulWidget {
  const KonversiUmurScreen({super.key});

  @override
  State<KonversiUmurScreen> createState() => _KonversiUmurScreenState();
}

class _KonversiUmurScreenState extends State<KonversiUmurScreen> {
  DateTime? tanggalLahir;
  String hasilUmur = '';

  Future<void> pilihTanggalLahir() async {
    final DateTime? tanggal = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (tanggal != null) {
      setState(() {
        tanggalLahir = tanggal;
        hasilUmur = '';
      });
    }
  }

  void hitungUmur() {
    if (tanggalLahir == null) {
      setState(() {
        hasilUmur = 'Silakan pilih tanggal lahir terlebih dahulu.';
      });
      return;
    }

    final sekarang = DateTime.now();

    int tahun = sekarang.year - tanggalLahir!.year;
    int bulan = sekarang.month - tanggalLahir!.month;
    int hari = sekarang.day - tanggalLahir!.day;

    if (hari < 0) {
      bulan--;
      final hariDalamBulanSebelumnya = DateTime(
        sekarang.year,
        sekarang.month,
        0,
      ).day;
      hari += hariDalamBulanSebelumnya;
    }

    if (bulan < 0) {
      tahun--;
      bulan += 12;
    }

    setState(() {
      hasilUmur = '$tahun tahun, $bulan bulan, $hari hari';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3C2A21),
      appBar: AppBar(
        title: const Text(
          'Konversi Umur',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.greenAccent,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              'Konversi Tanggal Lahir ke Umur',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFD5CEA3),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              color: const Color(0xFF2C1E16),
              child: ListTile(
                leading: const Icon(
                  Icons.cake_outlined,
                  color: Color(0xFFD5CEA3),
                ),
                title: Text(
                  tanggalLahir == null
                      ? 'Pilih tanggal lahir'
                      : '${tanggalLahir!.day}/${tanggalLahir!.month}/${tanggalLahir!.year}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                trailing: const Icon(
                  Icons.calendar_month,
                  color: Colors.greenAccent,
                ),
                onTap: pilihTanggalLahir,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: hitungUmur,
                child: const Text('Hitung Umur'),
              ),
            ),

            const SizedBox(height: 30),

            if (hasilUmur.isNotEmpty)
              Card(
                color: const Color(0xFF2C1E16),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Umur Anda',
                        style: TextStyle(
                          color: Color(0xFFD5CEA3),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        hasilUmur,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}