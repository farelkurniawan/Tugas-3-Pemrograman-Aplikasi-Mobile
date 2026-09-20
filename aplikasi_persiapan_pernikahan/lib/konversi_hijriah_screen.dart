import 'package:flutter/material.dart';
import 'package:hijri_date/hijri.dart';

class KonversiHijriahScreen extends StatefulWidget {
  const KonversiHijriahScreen({super.key});

  @override
  State<KonversiHijriahScreen> createState() =>
      _KonversiHijriahScreenState();
}

class _KonversiHijriahScreenState extends State<KonversiHijriahScreen> {
  DateTime? _selectedDate;
  String hijriResult = '';

  final List<String> _hariIndonesia = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    "Jum'at",
    'Sabtu',
    'Minggu',
  ];

  final List<String> _hijriMonths = [
    'Muharram',
    'Safar',
    'Rabiul Awal',
    'Rabiul Akhir',
    'Jumadil Awal',
    'Jumadil Akhir',
    'Rajab',
    'Sya’ban',
    'Ramadan',
    'Syawal',
    'Zulkaidah',
    'Zulhijah',
  ];

  void _prosesKonversiHijriah() {
    if (_selectedDate == null) {
      return;
    }

    final tanggalHijriah = HijriDate.fromDate(_selectedDate!);

    final hari = _hariIndonesia[_selectedDate!.weekday - 1];
    final bulan = _hijriMonths[tanggalHijriah.hMonth - 1];

    final hasil =
        '$hari, ${tanggalHijriah.hDay} $bulan ${tanggalHijriah.hYear} H';

    setState(() {
      hijriResult = hasil;
    });
  }

  Future<void> _pilihTanggal() async {
    final tanggal = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(100),
      lastDate: DateTime(2100),
    );

    if (tanggal == null) {
      return;
    }

    setState(() {
      _selectedDate = tanggal;
      hijriResult = '';
    });
  }

  String _formatTanggal(DateTime tanggal) {
    final bulan = [
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
      backgroundColor: const Color(0xFF21140D),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Konversi Hijriah',
          style: TextStyle(
            fontSize: 13,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            const Text(
              'Konversi tanggal Masehi ke tanggal Hijriah',
              style: TextStyle(
                color: Color(0xFFC9B98B),
                fontSize: 10,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF604534),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: Color(0xFFD6C78F),
                    size: 28,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Tanggal Masehi',
                    style: TextStyle(
                      color: Color(0xFFD0C0A5),
                      fontSize: 8,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    _selectedDate == null
                        ? _formatTanggal(DateTime.now())
                        : _formatTanggal(_selectedDate!),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    onPressed: _pilihTanggal,
                    icon: const Icon(
                      Icons.calendar_today,
                      size: 10,
                    ),
                    label: const Text(
                      'Pilih Tanggal',
                      style: TextStyle(
                        fontSize: 8,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD8D19C),
                      foregroundColor: const Color(0xFF4B3B25),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            const Icon(
              Icons.arrow_downward,
              color: Color(0xFFD1C58F),
              size: 22,
            ),

            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                16,
                15,
                16,
                18,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: const Color(0xFFC8B979),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Column(
                children: [
                  const Text(
                    'Tanggal Hijriah',
                    style: TextStyle(
                      color: Color(0xFFD0C0A5),
                      fontSize: 8,
                    ),
                  ),

                  const SizedBox(height: 8),

                  if (hijriResult.isEmpty)
                    const Text(
                      '-',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    Text(
                      hijriResult,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                  const SizedBox(height: 15),

                  if (hijriResult.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _infoHijriah(
                          'Hari',
                          _hariIndonesia[_selectedDate!.weekday - 1],
                        ),
                        _infoHijriah(
                          'Bulan',
                          _hijriMonths[
                              HijriDate.fromDate(_selectedDate!).hMonth - 1],
                        ),
                        _infoHijriah(
                          'Tahun',
                          '${HijriDate.fromDate(_selectedDate!).hYear} H',
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _prosesKonversiHijriah,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD8D19C),
                foregroundColor: const Color(0xFF4B3B25),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 9,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Konversi ke Hijriah',
                style: TextStyle(
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoHijriah(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFB7AA99),
            fontSize: 7,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 7,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}