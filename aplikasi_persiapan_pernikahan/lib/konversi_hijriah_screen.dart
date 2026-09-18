import 'package:flutter/material.dart';

class HijriConverter {
  static const List<String> namaBulanHijriah = [
    'Muharram',
    'Safar',
    'Rabiul Awal',
    'Rabiul Akhir',
    'Jumadil Awal',
    'Jumadil Akhir',
    'Rajab',
    "Sya'ban",
    'Ramadhan',
    'Syawal',
    "Dzulqa'dah",
    'Dzulhijjah'
  ];

  /// Konversi tanggal Masehi (Gregorian) ke Hijriah
  /// Menggunakan algoritma Kuwaiti Algorithm
  static Map<String, dynamic> masehiKeHijriah(DateTime tanggal) {
    int day = tanggal.day;
    int month = tanggal.month;
    int year = tanggal.year;

    // Konversi ke Julian Day Number (JDN)
    int a = (14 - month) ~/ 12;
    int y = year + 4800 - a;
    int m = month + 12 * a - 3;

    int jdn = day +
      // Rumus matematika unik untuk menghitung selisih jumlah hari antar bulan Masehi
      // yang tidak rata (ada yang 30 dan 31 hari).
      // Dalam satu tahun ada 365 hari
        ((153 * m + 2) ~/ 5) + 
        365 * y +
      // Perhitungan tahun kabisat dimana kabisat kan cuma 4 tahun sekali.
        (y ~/ 4) -
        (y ~/ 100) +
        (y ~/ 400) -
        32045; //angka penyeimbang dari kalender julian

    // Konversi JDN ke Hijriah
    // 1948440 adalah kalender julian dimulainya 1 hijriah/16 Juli 622 M
    // 10631 adalah total hari dalam kalender hijriah (30 tahun)
    int l = jdn - 1948440 + 10632;
    int n = ((l - 1) ~/ 10631);
    l = l - 10631 * n + 354;

    int j = (((10985 - l) ~/ 5316)) *
            ((50 * l) ~/ 17719) +
        ((l ~/ 5670)) *
            ((43 * l) ~/ 15238);

    l = l -
        (((30 - j) ~/ 15)) *
            (((17719 * j) ~/ 50)) -
        ((j ~/ 16)) *
            (((15238 * j) ~/ 43)) +
        29;

    int hijriMonth = ((24 * l) ~/ 709);
    int hijriDay = l - ((709 * hijriMonth) ~/ 24);
    int hijriYear = 30 * n + j - 30;

    return {
      'hari': hijriDay,
      'bulan': hijriMonth,
      'namaBulan': namaBulanHijriah[hijriMonth - 1],
      'tahun': hijriYear,
      'formatted':
          '$hijriDay ${namaBulanHijriah[hijriMonth - 1]} $hijriYear H',
    };
  }
}

class KonversiHijriahScreen extends StatefulWidget {
  const KonversiHijriahScreen({super.key});

  @override
  State<KonversiHijriahScreen> createState() =>
      _KonversiHijriahScreenState();
}

class _KonversiHijriahScreenState
    extends State<KonversiHijriahScreen> {
  DateTime tanggalMasehi = DateTime.now();

  Map<String, dynamic> hasilHijriah =
      HijriConverter.masehiKeHijriah(DateTime.now());

  Future<void> pilihTanggal() async {
    final DateTime? tanggal = await showDatePicker(
      context: context,
      initialDate: tanggalMasehi,
      firstDate: DateTime(100),
      lastDate: DateTime(2100),
    );

    if (tanggal != null) {
      setState(() {
        tanggalMasehi = tanggal;
        hasilHijriah =
            HijriConverter.masehiKeHijriah(tanggal);
      });
    }
  }

  String formatTanggalMasehi(DateTime tanggal) {
    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${tanggal.day} ${bulan[tanggal.month - 1]} ${tanggal.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3C2A21),

      appBar: AppBar(
        title: const Text(
          'Konversi Hijriah',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.greenAccent,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // Judul
            const Text(
              'Kalender Hijriah',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Konversi tanggal Masehi ke tanggal Hijriah',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 30),

            // Card tanggal Masehi
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF5A4032),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [

                  const Icon(
                    Icons.calendar_month,
                    color: Colors.greenAccent,
                    size: 50,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Tanggal Masehi',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    formatTanggalMasehi(tanggalMasehi),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: pilihTanggal,
                    icon: const Icon(Icons.date_range),
                    label: const Text('Pilih Tanggal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Icon konversi
            const Icon(
              Icons.arrow_downward,
              color: Colors.greenAccent,
              size: 35,
            ),

            const SizedBox(height: 15),

            // Hasil Hijriah
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.greenAccent,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [

                  const Text(
                    'Tanggal Hijriah',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    hasilHijriah['formatted'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    children: [

                      _infoHijriah(
                        'Hari',
                        '${hasilHijriah['hari']}',
                      ),

                      _infoHijriah(
                        'Bulan',
                        hasilHijriah['namaBulan'],
                      ),

                      _infoHijriah(
                        'Tahun',
                        '${hasilHijriah['tahun']} H',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoHijriah(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}