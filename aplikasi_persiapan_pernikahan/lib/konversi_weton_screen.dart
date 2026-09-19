import 'package:flutter/material.dart';

class WetonConverter {
  static const List<String> namaHari = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    "Jum'at",
    'Sabtu',
    'Minggu'
  ];

  static const List<String> namaPasaran = [
    'Legi',
    'Pahing',
    'Pon',
    'Wage',
    'Kliwon'
  ];

  // Neptu (nilai)  masehi dalam hitungan Jawa
  static const Map<String, int> neptuHari = {
    'Senin': 4,
    'Selasa': 3,
    'Rabu': 7,
    'Kamis': 8,
    "Jum'at": 6,
    'Sabtu': 9,
    'Minggu': 5,
  };

  // Neptu pasaran dalam perhitungan kalender jawa
  static const Map<String, int> neptuPasaran = {
    'Legi': 5,
    'Pahing': 9,
    'Pon': 7,
    'Wage': 4,
    'Kliwon': 8,
  };

  // Tanggal acuan: 17 Agustus 1945 = Jum'at Legi
  static final DateTime _anchor = DateTime(1945, 8, 17);

  // Index Legi di namaPasaran
  static const int _anchorPasaranIndex = 0;

  static Map<String, dynamic> tanggalKeWeton(DateTime tanggal) {
    // Menentukan nama hari
    String hari = namaHari[tanggal.weekday - 1];

    // Menghitung selisih hari dari tanggal acuan
    int selisihHari = tanggal.difference(_anchor).inDays;

    // Menentukan pasaran
    int pasaranIndex =
        ((_anchorPasaranIndex + selisihHari) % 5 + 5) % 5;

    String pasaran = namaPasaran[pasaranIndex];

    // Menghitung total neptu
    int neptu =
        (neptuHari[hari] ?? 0) +
        (neptuPasaran[pasaran] ?? 0);

    return {
      'hari': hari,
      'pasaran': pasaran,
      'weton': '$hari $pasaran',
      'neptuHari': neptuHari[hari],
      'neptuPasaran': neptuPasaran[pasaran],
      'neptuTotal': neptu,
    };
  }
}

class KonversiWetonScreen extends StatefulWidget {
  const KonversiWetonScreen({super.key});

  @override
  State<KonversiWetonScreen> createState() =>
      _KonversiWetonScreenState();
}

class _KonversiWetonScreenState extends State<KonversiWetonScreen> {
  DateTime tanggalMasehi = DateTime.now();

  Map<String, dynamic> hasilWeton =
      WetonConverter.tanggalKeWeton(DateTime.now());

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
        hasilWeton = WetonConverter.tanggalKeWeton(tanggal);
      });
    }
  }

  String formatTanggal(DateTime tanggal) {
    const List<String> namaBulan = [
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

    return '${tanggal.day} ${namaBulan[tanggal.month - 1]} ${tanggal.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A120B),

      appBar: AppBar(
        title: const Text(
          'Konversi Kalender Weton',
          style: TextStyle(
            color: Color(0xFFD5CEA3),
          ),
        ),
        backgroundColor: const Color(0xFF3C2A21),
        iconTheme: const IconThemeData(
          color: Color(0xFFD5CEA3),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            const Text(
              'Kalender Weton Jawa',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFE5E5CB),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Menentukan weton berdasarkan tanggal Masehi',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF3C2A21),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                children: [

                  const Icon(
                    Icons.calendar_month,
                    color: Color(0xFFD5CEA3),
                    size: 50,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Tanggal Masehi',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    formatTanggal(tanggalMasehi),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFE5E5CB),
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
                      backgroundColor: const Color(0xFFD5CEA3),
                      foregroundColor: const Color(0xFF1A120B),

                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 13,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Icon(
              Icons.arrow_downward,
              color: Color(0xFFD5CEA3),
              size: 35,
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(
                color: const Color(0xFF3C2A21),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFD5CEA3),
                  width: 1.5,
                ),
              ),

              child: Column(
                children: [

                  const Text(
                    'Hasil Weton',
                    style: TextStyle(
                      color: Color(0xFFD5CEA3),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    hasilWeton['weton'],
                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      color: Color(0xFFE5E5CB),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [

                      _infoWeton(
                        'Hari',
                        hasilWeton['hari'],
                      ),

                      _infoWeton(
                        'Pasaran',
                        hasilWeton['pasaran'],
                      ),

                      _infoWeton(
                        'Neptu',
                        '${hasilWeton['neptuTotal']}',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: const Color(0xFF1A120B),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Column(
                      children: [

                        const Text(
                          'Detail Neptu',
                          style: TextStyle(
                            color: Color(0xFFD5CEA3),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          'Neptu Hari : ${hasilWeton['neptuHari']}',
                          style: const TextStyle(
                            color: Color(0xFFE5E5CB),
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          'Neptu Pasaran : ${hasilWeton['neptuPasaran']}',
                          style: const TextStyle(
                            color: Color(0xFFE5E5CB),
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          'Total Neptu : ${hasilWeton['neptuTotal']}',
                          style: const TextStyle(
                            color: Color(0xFFE5E5CB),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoWeton(String label, String value) {
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

          const SizedBox(height: 6),

          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFE5E5CB),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}