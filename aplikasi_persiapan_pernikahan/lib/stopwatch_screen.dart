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
  bool _isStopped = false; 

  String _formatTime(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr.$hundredsStr";
  }

  // Fungsi Play
  void _startStopwatch() {
    if (_isStopped) return; 
    
    setState(() {
      _stopwatch.start();
    });
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  // Fungsi Pause (Jeda Sementara)
  void _pauseStopwatch() {
    setState(() {
      _stopwatch.stop();
    });
  }

  // Fungsi Stop (Berhenti Total)
  void _stopStopwatch() {
    setState(() {
      _stopwatch.stop();
      _isStopped = true; // Mengunci stopwatch agar tidak bisa di-play lagi sebelum reset
      
      // (Opsional) Otomatis mencatat waktu terakhir saat ditekan Stop
      if (_stopwatch.elapsedMilliseconds > 0) {
        _laps.insert(0, "Waktu Final: ${_formatTime(_stopwatch.elapsedMilliseconds)}");
      }
    });
    _timer?.cancel();
  }

  // Fungsi Reset (Kembali ke 0)
  void _resetStopwatch() {
    setState(() {
      _stopwatch.stop();
      _stopwatch.reset();
      _laps.clear(); 
      _isStopped = false; // Membuka kunci agar bisa di-play lagi dari 0
    });
    _timer?.cancel();
  }

  // Fungsi Lap (Catat Waktu)
  void _addLap() {
    if (_stopwatch.isRunning) {
      setState(() {
        _laps.insert(0, _formatTime(_stopwatch.elapsedMilliseconds)); 
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
            
            // LINGKARAN ANGKA WAKTU
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isStopped ? Colors.redAccent.withOpacity(0.5) : const Color(0xFF3C2A21), 
                  width: 8
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isStopped 
                        ? Colors.redAccent.withOpacity(0.1) 
                        : const Color(0xFFD5CEA3).withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Text(
                _formatTime(_stopwatch.elapsedMilliseconds),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                  color: _isStopped ? Colors.redAccent : const Color(0xFFE5E5CB),
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // KUMPULAN 4 TOMBOL
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. Tombol Reset (Abu-abu)
                _buildControlButton(
                  icon: Icons.refresh,
                  onPressed: _resetStopwatch,
                  color: Colors.white54,
                ),
                const SizedBox(width: 15),

                // 2. Tombol Stop Total (Kotak Merah)
                _buildControlButton(
                  icon: Icons.stop,
                  onPressed: (_stopwatch.isRunning || (_stopwatch.elapsedMilliseconds > 0 && !_isStopped)) 
                      ? _stopStopwatch 
                      : null,
                  color: Colors.redAccent,
                ),
                const SizedBox(width: 15),

                // 3. Tombol Play / Pause (Emas / Tengah)
                FloatingActionButton(
                  onPressed: _isStopped 
                      ? null // Jika sudah stop total, tombol play mati (harus di-reset dulu)
                      : (_stopwatch.isRunning ? _pauseStopwatch : _startStopwatch),
                  backgroundColor: _isStopped ? Colors.grey[800] : const Color(0xFFD5CEA3),
                  elevation: 5,
                  child: Icon(
                    _stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
                    color: _isStopped ? Colors.white38 : const Color(0xFF1A120B),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 15),

                // 4. Tombol Lap / Catatan Waktu (Bendera)
                _buildControlButton(
                  icon: Icons.flag_outlined,
                  onPressed: _stopwatch.isRunning ? _addLap : null,
                  color: _stopwatch.isRunning ? const Color(0xFFD5CEA3) : Colors.white38,
                ),
              ],
            ),
            const SizedBox(height: 30),

            // DAFTAR LAP
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
                          // Jika itu "Waktu Final" karena tombol stop ditekan
                          bool isFinal = _laps[index].contains("Waktu Final");
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isFinal ? 'SELESAI' : 'Lap ${_laps.length - index}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isFinal ? FontWeight.bold : FontWeight.normal,
                                    color: isFinal ? Colors.redAccent : Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                Text(
                                  isFinal ? _laps[index].replaceAll("Waktu Final: ", "") : _laps[index],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isFinal ? Colors.redAccent : const Color(0xFFD5CEA3),
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