import 'package:flutter/material.dart';

class HitungWetonScreen extends StatefulWidget {
  const HitungWetonScreen({super.key});

  @override
  State<HitungWetonScreen> createState() => _HitungWetonScreenState();
}

class _HitungWetonScreenState extends State<HitungWetonScreen> {
  final Map<String, int> nilaiHari = {
    'Senin': 4, 'Selasa': 3, 'Rabu': 7, 'Kamis': 8, 'Jumat': 6, 'Sabtu': 9, 'Minggu': 5
  };
  final Map<String, int> nilaiPasaran = {
    'Legi': 5, 'Pahing': 9, 'Pon': 7, 'Wage': 4, 'Kliwon': 8
  };

  final TextEditingController tglPriaController = TextEditingController();
  final TextEditingController tglWanitaController = TextEditingController();

  String wetonPria = '';
  String wetonWanita = '';
  int neptuPria = 0;
  int neptuWanita = 0;

  String hasilKecocokan = '';
  String deskripsiKecocokan = '';
  int totalNeptu = 0;

  void hitungWetonDariTanggal(DateTime date, bool isPria) {
    List<String> daftarHari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    String hari = daftarHari[date.weekday - 1];

    DateTime acuan = DateTime.utc(1970, 1, 1);
    DateTime target = DateTime.utc(date.year, date.month, date.day);
    
    int selisihHari = target.difference(acuan).inDays;
    List<String> daftarPasaran = ['Wage', 'Kliwon', 'Legi', 'Pahing', 'Pon'];
    
    int indeksPasaran = (selisihHari % 5 + 5) % 5;
    String pasaran = daftarPasaran[indeksPasaran];

    setState(() {
      if (isPria) {
        wetonPria = "$hari $pasaran";
        neptuPria = nilaiHari[hari]! + nilaiPasaran[pasaran]!;
        tglPriaController.text = "${date.day}/${date.month}/${date.year}";
      } else {
        wetonWanita = "$hari $pasaran";
        neptuWanita = nilaiHari[hari]! + nilaiPasaran[pasaran]!;
        tglWanitaController.text = "${date.day}/${date.month}/${date.year}";
      }
      hasilKecocokan = ''; 
    });
  }

  void prosesKecocokan() {
    if (neptuPria == 0 || neptuWanita == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih tanggal lahir kedua belah pihak terlebih dahulu!')),
      );
      return;
    }

    setState(() {
      totalNeptu = neptuPria + neptuWanita;
      int sisa = totalNeptu % 8;

      switch (sisa) {
        case 1:
          hasilKecocokan = "Pegat";
          deskripsiKecocokan = "Berpotensi sering menghadapi masalah, ekonomi, maupun rintangan hidup yang bisa berujung perpisahan.";
          break;
        case 2:
          hasilKecocokan = "Ratu";
          deskripsiKecocokan = "Sangat harmonis, dihargai tetangga, dan lingkungan sekitar. Jodoh yang sangat baik.";
          break;
        case 3:
          hasilKecocokan = "Jodoh";
          deskripsiKecocokan = "Sangat cocok. Bisa saling menerima kelebihan dan kekurangan masing-masing. Rumah tangga rukun.";
          break;
        case 4:
          hasilKecocokan = "Topo";
          deskripsiKecocokan = "Akan mengalami kesulitan di awal pernikahan, namun perlahan akan bahagia dan sukses di kemudian hari.";
          break;
        case 5:
          hasilKecocokan = "Tinari";
          deskripsiKecocokan = "Akan menemukan kebahagiaan, murah rezeki, dan selalu dilindungi dari kekurangan.";
          break;
        case 6:
          hasilKecocokan = "Padu";
          deskripsiKecocokan = "Akan sering mengalami pertengkaran (cekcok) ringan, namun tidak sampai berujung perceraian.";
          break;
        case 7:
          hasilKecocokan = "Sujanan";
          deskripsiKecocokan = "Berpotensi menghadapi pertengkaran besar, biasanya dipicu oleh masalah kesalahpahaman/orang ketiga.";
          break;
        case 0:
          hasilKecocokan = "Pesthi";
          deskripsiKecocokan = "Rumah tangga akan berjalan rukun, tenteram, dan damai sampai tua tanpa masalah berarti.";
          break;
      }
    });
  }

  Widget buildDateInput(String label, TextEditingController controller, String infoWeton, bool isPria) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFD7C0AE), fontSize: 14)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          readOnly: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Pilih Tanggal Lahir',
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.black45,
            suffixIcon: const Icon(Icons.calendar_month, color: Color(0xFF3C2A21)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF3C2A21))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white)),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime(2000),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: Color(0xFF3C2A21), onPrimary: Colors.white, onSurface: Colors.white, surface: Color(0xFF1E1511),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              hitungWetonDariTanggal(pickedDate, isPria);
            }
          },
        ),
        if (infoWeton.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 4.0),
            child: Text('Weton: $infoWeton (Neptu: ${isPria ? neptuPria : neptuWanita})', 
                style: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic)),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3C2A21),
      appBar: AppBar(
        title: const Text('Hitung Kecocokan Weton', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFF3C2A21)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildDateInput('Tanggal Lahir Calon Pria', tglPriaController, wetonPria, true),
            buildDateInput('Tanggal Lahir Calon Wanita', tglWanitaController, wetonWanita, false),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3C2A21),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                side: const BorderSide(color: Color(0xFFD7C0AE), width: 1),
              ),
              onPressed: prosesKecocokan,
              child: const Text('Hitung Kecocokan'),
            ),
            const SizedBox(height: 30),
            if (hasilKecocokan.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF3C2A21), width: 2),
                ),
                child: Column(
                  children: [
                    const Text('Hasil Perhitungan', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 10),
                    Text('Total Neptu: $totalNeptu', style: const TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 5),
                    Text(
                      hasilKecocokan,
                      style: const TextStyle(color: Color(0xFFD7C0AE), fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      deskripsiKecocokan,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}