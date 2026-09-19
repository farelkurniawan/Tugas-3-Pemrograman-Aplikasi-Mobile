import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Halaman CRUD acara penting pada koleksi Firestore `acara_penting`.
/// Data dibaca real-time melalui [StreamBuilder].
class AcaraPentingScreen extends StatelessWidget {
  const AcaraPentingScreen({super.key});

  /// Membuka form tambah atau edit di dalam modal bottom sheet.
  /// Snapshot null berarti Create; snapshot berisi berarti Update.
  void _showForm(BuildContext context, [DocumentSnapshot? documentSnapshot]) {
    // Controller menyimpan nilai yang akan ditampilkan dan dikirim ke Firestore.
    final TextEditingController namaAcaraController = TextEditingController();
    final TextEditingController tanggalController = TextEditingController();
    final TextEditingController waktuController = TextEditingController();

    // Dipakai sebagai nilai awal picker dan dasar validasi waktu.
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    // Mode Edit: muat data lama dan ubah kembali ke objek tanggal/waktu.
    if (documentSnapshot != null) {
      namaAcaraController.text = documentSnapshot['nama_acara'];
      String tglStr = documentSnapshot['tanggal'];
      // Default ini menjaga dokumen lama tanpa field waktu tetap bisa dibuka.
      String wktStr = documentSnapshot.data().toString().contains('waktu') ? documentSnapshot['waktu'] : '00:00 WIB';
      
      tanggalController.text = tglStr;
      waktuController.text = wktStr;

      try {
        // Parsing format tanggal DD/MM/YYYY menjadi komponen DateTime.
        List<String> partsTgl = tglStr.split('/');
        int day = int.parse(partsTgl[0]);
        int month = int.parse(partsTgl[1]);
        int year = int.parse(partsTgl[2]);

        // Hapus " WIB", lalu parsing jam dan menit menjadi TimeOfDay.
        String cleanTime = wktStr.replaceAll(' WIB', '');
        List<String> partsWkt = cleanTime.split(':');
        int hour = int.parse(partsWkt[0]);
        int minute = int.parse(partsWkt[1]);

        selectedDate = DateTime(year, month, day);
        selectedTime = TimeOfDay(hour: hour, minute: minute);
      } catch (e) {
        // Fallback jika format data lama tidak sesuai pola yang diharapkan.
        selectedDate = DateTime.now();
        selectedTime = TimeOfDay.now();
      }
    }

    // Bottom sheet menampilkan form tanpa berpindah halaman.
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF3C2A21),
      // Form naik mengikuti keyboard saat input aktif.
      isScrollControlled: true,
      builder: (BuildContext context) {
        // StatefulBuilder cukup untuk memperbarui pilihan di dalam modal.
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    documentSnapshot == null ? 'Tambah Acara Baru' : 'Edit Acara',
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  
                  TextField(
                    controller: namaAcaraController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Nama Acara',
                      labelStyle: TextStyle(color: Color(0xFFD5CEA3)),  
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD5CEA3))),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                  
                  // readOnly memaksa tanggal dipilih lewat date picker.
                  TextField(
                    controller: tanggalController,
                    style: const TextStyle(color: Colors.white),
                    readOnly: true, 
                    decoration: const InputDecoration(
                      labelText: 'Tanggal',
                      labelStyle: TextStyle(color: Color(0xFFD5CEA3)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD5CEA3))),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      suffixIcon: Icon(Icons.calendar_today, color: Color(0xFFD5CEA3)),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        // Acara lama tidak boleh dipilih dari kalender.
                        firstDate: DateTime.now(), 
                        lastDate: DateTime(2100),  
                        builder: (context, child) {
                          // Tema picker disamakan dengan warna halaman.
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: Color(0xFFD5CEA3), 
                                onPrimary: Colors.black, 
                                onSurface: Colors.white, 
                                surface: Color(0xFF3C2A21), 
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        setStateModal(() {
                          selectedDate = pickedDate;
                          tanggalController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        });
                      }
                    },
                  ),

                  // readOnly membuat waktu hanya dipilih lewat time picker.
                  TextField(
                    controller: waktuController,
                    style: const TextStyle(color: Colors.white),
                    readOnly: true, 
                    decoration: const InputDecoration(
                      labelText: 'Waktu',
                      labelStyle: TextStyle(color: Color(0xFFD5CEA3)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD5CEA3))),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      suffixIcon: Icon(Icons.access_time, color: Color(0xFFD5CEA3)),
                    ),
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime ?? TimeOfDay.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: Color(0xFFD5CEA3), 
                                onPrimary: Colors.black, 
                                onSurface: Colors.white, 
                                surface: Color(0xFF3C2A21), 
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedTime != null) {
                        setStateModal(() {
                          selectedTime = pickedTime;
                          String hourStr = pickedTime.hour.toString().padLeft(2, '0');
                          String minuteStr = pickedTime.minute.toString().padLeft(2, '0');
                          waktuController.text = "$hourStr:$minuteStr WIB";
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD5CEA3),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () async {
                        // Validasi field wajib sebelum mengakses Firestore.
                        if (namaAcaraController.text.isEmpty || tanggalController.text.isEmpty || waktuController.text.isEmpty) {
                          // AlertDialog membuat peringatan tetap terlihat di atas form.
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: const Color(0xFF3C2A21),
                              title: const Text('Peringatan', style: TextStyle(color: Colors.redAccent)),
                              content: const Text('Semua field harus diisi!', style: TextStyle(color: Colors.white)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK', style: TextStyle(color: Color(0xFFD5CEA3))),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        // Cek gabungan tanggal dan waktu, termasuk jam lampau hari ini.
                        if (selectedDate != null && selectedTime != null) {
                          DateTime targetDateTime = DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          );

                          // firstDate hanya memeriksa tanggal; isBefore juga memeriksa jam.
                          if (targetDateTime.isBefore(DateTime.now())) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: const Color(0xFF3C2A21),
                                title: const Text('Peringatan', style: TextStyle(color: Colors.redAccent)),
                                content: const Text(
                                  'Tidak dapat memilih tanggal/waktu yang sudah lewat!',
                                  style: TextStyle(color: Colors.white),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('OK', style: TextStyle(color: Color(0xFFD5CEA3))),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }
                        }

                        // Create: add membuat dokumen baru dengan ID otomatis.
                        if (documentSnapshot == null) {
                          await FirebaseFirestore.instance.collection('acara_penting').add({
                            'nama_acara': namaAcaraController.text,
                            'tanggal': tanggalController.text,
                            'waktu': waktuController.text,
                          });
                        } else {
                          // Update: ID snapshot menunjuk dokumen yang diedit.
                          await FirebaseFirestore.instance.collection('acara_penting').doc(documentSnapshot.id).update({
                            'nama_acara': namaAcaraController.text,
                            'tanggal': tanggalController.text,
                            'waktu': waktuController.text,
                          });
                        }
                        // Tutup modal setelah operasi Firestore selesai.
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      child: Text(documentSnapshot == null ? 'Simpan' : 'Update'),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3C2A21),
      appBar: AppBar(
        title: const Text('Acara Penting', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFFD5CEA3)),
      ),
      // snapshots() mengirim ulang data saat dokumen ditambah, diubah, atau dihapus.
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('acara_penting').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            if (streamSnapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('Belum ada acara penting. Silakan tambah.', style: TextStyle(color: Colors.white)),
              );
            }
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                // Snapshot dipakai untuk menampilkan data dan mengambil ID CRUD.
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                
                Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                String namaAcara = data['nama_acara'] ?? '';
                String tanggal = data['tanggal'] ?? '';
                String waktu = data.containsKey('waktu') && data['waktu'] != '' ? data['waktu'] : '-';

                return Card(
                  color: Colors.black45,
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.event_note, color: Color(0xFFD5CEA3), size: 30),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(namaAcara, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('Tanggal: $tanggal', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                              Text('Waktu: $waktu', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Color(0xFFD5CEA3)),
                              onPressed: () => _showForm(context, documentSnapshot),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                            const SizedBox(height: 8),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () async {
                                bool confirm = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: const Color(0xFF3C2A21),
                                    title: const Text('Hapus Acara?', style: TextStyle(color: Colors.white)),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text('Batal', style: TextStyle(color: Color(0xFFD5CEA3))),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text('Hapus', style: TextStyle(color: Colors.redAccent)),
                                      ),
                                    ],
                                  ),
                                ) ?? false;

                                if (confirm) {
                                  // Delete berdasarkan ID dokumen yang dikonfirmasi.
                                  await FirebaseFirestore.instance.collection('acara_penting').doc(documentSnapshot.id).delete();
                                }
                              },
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator(color: Color(0xFFD5CEA3)));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFD5CEA3),
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}