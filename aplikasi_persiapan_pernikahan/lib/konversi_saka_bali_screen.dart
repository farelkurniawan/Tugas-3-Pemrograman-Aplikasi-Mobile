import 'package:flutter/material.dart';

class KonversiSakaBaliScreen extends StatefulWidget {
  const KonversiSakaBaliScreen({super.key});

  @override
  State<KonversiSakaBaliScreen> createState() =>
      _KonversiSakaBaliScreenState();
}

class _KonversiSakaBaliScreenState extends State<KonversiSakaBaliScreen> {
  DateTime? tanggalDipilih;

  String hasilSaptawara = '';
  String hasilPancawara = '';
  String hasilWuku = '';
  String hasilSasih = '';
  String hasilSaka = '';

  // Urutan Wuku dalam kalender Bali.
  static const List<String> wuku = [
    'Sinta',
    'Landep',
    'Ukir',
    'Kulantir',
    'Tolu',
    'Gumbreg',
    'Wariga',
    'Warigadean',
    'Julungwangi',
    'Sungsang',
    'Dungulan',
    'Kuningan',
    'Langkir',
    'Medangsia',
    'Pujut',
    'Paang',
    'Krulut',
    'Merakih',
    'Tambir',
    'Medangkungan',
    'Matal',
    'Uye',
    'Menail',
    'Prangbakat',
    'Bala',
    'Ugu',
    'Wayang',
    'Kulawu',
    'Dukut',
    'Watugunung',
  ];

  // Urutan Saptawara.
  static const List<String> saptawara = [
    'Redite',
    'Coma',
    'Anggara',
    'Buda',
    'Wraspati',
    'Sukra',
    'Saniscara',
  ];

  // Urutan Pancawara.
  static const List<String> pancawara = [
    'Umanis',
    'Paing',
    'Pon',
    'Wage',
    'Kliwon',
  ];

  // Nama Sasih.
  static const List<String> sasih = [
    'Kasa',
    'Karo',
    'Katiga',
    'Kapat',
    'Kalima',
    'Kanem',
    'Kapitu',
    'Kawolu',
    'Kasanga',
    'Kadasa',
    'Jyesta',
    'Sada',
  ];

  Future<void> pilihTanggal() async {
    final DateTime? tanggal = await showDatePicker(
      context: context,
      initialDate: tanggalDipilih ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (tanggal != null) {
      setState(() {
        tanggalDipilih = tanggal;

        hasilSaptawara = '';
        hasilPancawara = '';
        hasilWuku = '';
        hasilSasih = '';
        hasilSaka = '';
      });
    }
  }

  // Menghitung selisih hari.
  int selisihHari(DateTime a, DateTime b) {
    final aDate = DateTime(a.year, a.month, a.day);
    final bDate = DateTime(b.year, b.month, b.day);

    return aDate.difference(bDate).inDays;
  }

  
  String hitungSaptawara(DateTime tanggal) {
    return saptawara[tanggal.weekday % 7];
  }

  
  // Siklus Pancawara berulang setiap 5 hari.
  String hitungPancawara(DateTime tanggal) {
    final DateTime acuan = DateTime(2026, 3, 22);
    final int selisih = selisihHari(tanggal, acuan);

    int index = (2 + selisih) % 5;

    if (index < 0) {
      index += 5;
    }

    return pancawara[index];
  }

  // Wuku mempunyai siklus 210 hari.
  
  String hitungWuku(DateTime tanggal) {
    final DateTime acuan = DateTime(2026, 3, 22);
    final int selisih = selisihHari(tanggal, acuan);

    int posisi = (28 * 7) + selisih;

    posisi %= 210;

    if (posisi < 0) {
      posisi += 210;
    }

    final int nomorWuku = posisi ~/ 7;

    return wuku[nomorWuku];
  }

  // Tahun Saka.
 
  int hitungSaka(DateTime tanggal) {
    int tahunSaka = tanggal.year - 78;

    // Tanggal Nyepi yang digunakan sebagai batas tahun Saka.
    //
    // Data tahun-tahun modern yang umum digunakan.
    final Map<int, DateTime> nyepi = {
      2024: DateTime(2024, 3, 11),
      2025: DateTime(2025, 3, 29),
      2026: DateTime(2026, 3, 19),
      2027: DateTime(2027, 3, 9),
      2028: DateTime(2028, 3, 26),
      2029: DateTime(2029, 3, 15),
      2030: DateTime(2030, 3, 5),
    };

    final DateTime? batas = nyepi[tanggal.year];

    if (batas != null && tanggal.isBefore(batas)) {
      tahunSaka--;
    }

    return tahunSaka;
  }

  
  String hitungSasih(DateTime tanggal) {
    
    final DateTime acuan = DateTime(2026, 3, 19);
    final int selisih = selisihHari(tanggal, acuan);

    if (selisih >= 0 && selisih < 365) {
      if (selisih < 31) {
        return 'Kadasa';
      } else if (selisih < 61) {
        return 'Jyesta';
      } else if (selisih < 91) {
        return 'Sada';
      } else if (selisih < 121) {
        return 'Kasa';
      } else if (selisih < 151) {
        return 'Karo';
      } else if (selisih < 181) {
        return 'Katiga';
      } else if (selisih < 211) {
        return 'Kapat';
      } else if (selisih < 241) {
        return 'Kalima';
      } else if (selisih < 271) {
        return 'Kanem';
      } else if (selisih < 301) {
        return 'Kapitu';
      } else if (selisih < 331) {
        return 'Kawolu';
      } else {
        return 'Kasanga';
      }
    }

    // Untuk tanggal di luar periode acuan modern,
    // tampilkan sasih berdasarkan perkiraan posisi tahun.
    final int bulan = tanggal.month;

    if (bulan == 1) {
      return 'Kapitu';
    } else if (bulan == 2) {
      return 'Kawolu';
    } else if (bulan == 3) {
      return 'Kasanga';
    } else if (bulan == 4) {
      return 'Kadasa';
    } else if (bulan == 5) {
      return 'Jyesta';
    } else if (bulan == 6) {
      return 'Sada';
    } else if (bulan == 7) {
      return 'Kasa';
    } else if (bulan == 8) {
      return 'Karo';
    } else if (bulan == 9) {
      return 'Katiga';
    } else if (bulan == 10) {
      return 'Kapat';
    } else if (bulan == 11) {
      return 'Kalima';
    } else {
      return 'Kanem';
    }
  }

  void konversi() {
    if (tanggalDipilih == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih tanggal terlebih dahulu.'),
        ),
      );
      return;
    }

    final tanggal = tanggalDipilih!;

    setState(() {
      hasilSaptawara = hitungSaptawara(tanggal);
      hasilPancawara = hitungPancawara(tanggal);
      hasilWuku = hitungWuku(tanggal);
      hasilSasih = hitungSasih(tanggal);
      hasilSaka = hitungSaka(tanggal).toString();
    });
  }

  Widget hasilCard(String judul, String isi, IconData icon) {
    return Card(
      color: const Color(0xFF2C1E16),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFFD5CEA3),
        ),
        title: Text(
          judul,
          style: const TextStyle(
            color: Color(0xFFD5CEA3),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            isi,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3C2A21),
      appBar: AppBar(
        title: const Text(
          'Konversi Saka Bali',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.greenAccent,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              'Konversi Kalender Saka Bali',
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
                  Icons.calendar_month,
                  color: Color(0xFFD5CEA3),
                ),
                title: Text(
                  tanggalDipilih == null
                      ? 'Pilih tanggal Masehi'
                      : '${tanggalDipilih!.day}/${tanggalDipilih!.month}/${tanggalDipilih!.year}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                trailing: const Icon(
                  Icons.date_range,
                  color: Colors.greenAccent,
                ),
                onTap: pilihTanggal,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: konversi,
                child: const Text('Konversi'),
              ),
            ),

            const SizedBox(height: 30),

            if (hasilSaptawara.isNotEmpty) ...[
              hasilCard(
                'Saptawara',
                hasilSaptawara,
                Icons.today,
              ),

              hasilCard(
                'Pancawara',
                hasilPancawara,
                Icons.loop,
              ),

              hasilCard(
                'Wuku',
                hasilWuku,
                Icons.date_range,
              ),

              hasilCard(
                'Sasih',
                hasilSasih,
                Icons.dark_mode_outlined,
              ),

              hasilCard(
                'Tahun Saka',
                hasilSaka,
                Icons.brightness_5_outlined,
              ),

              const SizedBox(height: 10),

              Card(
                color: const Color(0xFF2C1E16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '$hasilSaptawara $hasilPancawara, '
                    'Wuku $hasilWuku\n'
                    'Sasih $hasilSasih, Saka $hasilSaka',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFD5CEA3),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}