import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  final List<String> _laps = [];

  // Fungsi untuk memformat waktu ke MM:SS:MS
  String _formatTime(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr.$hundredsStr";
  }

  // Fungsi menjalankan Stopwatch
  void _startStopwatch() {
    setState(() {
      _stopwatch.start();
    });
    // Update UI setiap 30 milidetik agar angka terlihat berjalan mulus
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  // Fungsi menghentikan Stopwatch (Pause)
  void _stopStopwatch() {
    setState(() {
      _stopwatch.stop();
    });
    _timer?.cancel();
  }

  // Fungsi mereset Stopwatch
  void _resetStopwatch() {
    _stopStopwatch();
    setState(() {
      _stopwatch.reset();
      _laps.clear(); // Hapus semua catatan Lap
    });
  }

  // Fungsi mencatat waktu (Lap)
  void _addLap() {
    if (_stopwatch.isRunning) {
      setState(() {
        _laps.insert(0, _formatTime(_stopwatch.elapsedMilliseconds)); // Masukkan di paling atas
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A120B),
      appBar: AppBar(
        title: Text(
          'Stopwatch',
          style: GoogleFonts.philosopher(
            color: const Color(0xFFD5CEA3),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xFF1A120B),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // TAMPILAN ANGKA WAKTU
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF3C2A21), width: 8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD5CEA3).withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Text(
                _formatTime(_stopwatch.elapsedMilliseconds),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFFE5E5CB),
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // TOMBOL KONTROL (START, PAUSE, LAP, RESET)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol Reset
                _buildControlButton(
                  icon: Icons.refresh,
                  onPressed: _resetStopwatch,
                  color: Colors.redAccent,
                ),
                const SizedBox(width: 20),
                
                // Tombol Play / Pause (Otomatis berubah)
                FloatingActionButton(
                  onPressed: _stopwatch.isRunning ? _stopStopwatch : _startStopwatch,
                  backgroundColor: const Color(0xFFD5CEA3),
                  elevation: 5,
                  child: Icon(
                    _stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
                    color: const Color(0xFF1A120B),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                
                // Tombol Lap (Catatan)
                _buildControlButton(
                  icon: Icons.flag_outlined,
                  onPressed: _stopwatch.isRunning ? _addLap : null,
                  color: _stopwatch.isRunning ? const Color(0xFFD5CEA3) : Colors.white38,
                ),
              ],
            ),
            const SizedBox(height: 30),

            // DAFTAR LAP (CATATAN WAKTU)
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF2C1E16),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: _laps.isEmpty
                    ? Center(
                        child: Text(
                          'Belum ada catatan waktu',
                          style: TextStyle(color: Colors.white.withOpacity(0.4)),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _laps.length,
                        itemBuilder: (context, index) {
                          // Nomor urut lap (karena urutan dibalik dari paling baru)
                          int lapNumber = _laps.length - index;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Lap $lapNumber',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                Text(
                                  _laps[index],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFD5CEA3),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget kustom untuk tombol kontrol agar bentuknya rapi
  Widget _buildControlButton({required IconData icon, required VoidCallback? onPressed, required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3C2A21),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.5), width: 2),
      ),
      child: IconButton(
        icon: Icon(icon),
        color: color,
        iconSize: 24,
        onPressed: onPressed,
      ),
    );
  }
}