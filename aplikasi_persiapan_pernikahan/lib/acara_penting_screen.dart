import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AcaraPentingScreen extends StatelessWidget {
  const AcaraPentingScreen({super.key});

  void _showForm(BuildContext context, [DocumentSnapshot? documentSnapshot]) {
    final TextEditingController namaAcaraController = TextEditingController();
    final TextEditingController tanggalController = TextEditingController();
    final TextEditingController waktuController = TextEditingController();

    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    if (documentSnapshot != null) {
      namaAcaraController.text = documentSnapshot['nama_acara'];
      String tglStr = documentSnapshot['tanggal'];
      String wktStr = documentSnapshot.data().toString().contains('waktu') ? documentSnapshot['waktu'] : '00:00 WIB';
      
      tanggalController.text = tglStr;
      waktuController.text = wktStr;

      try {
        List<String> partsTgl = tglStr.split('/');
        int day = int.parse(partsTgl[0]);
        int month = int.parse(partsTgl[1]);
        int year = int.parse(partsTgl[2]);

        String cleanTime = wktStr.replaceAll(' WIB', '');
        List<String> partsWkt = cleanTime.split(':');
        int hour = int.parse(partsWkt[0]);
        int minute = int.parse(partsWkt[1]);

        selectedDate = DateTime(year, month, day);
        selectedTime = TimeOfDay(hour: hour, minute: minute);
      } catch (e) {
        selectedDate = DateTime.now();
        selectedTime = TimeOfDay.now();
      }
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF3C2A21),
      isScrollControlled: true,
      builder: (BuildContext context) {
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
                      labelStyle: TextStyle(color: Colors.greenAccent),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                  
                  TextField(
                    controller: tanggalController,
                    style: const TextStyle(color: Colors.white),
                    readOnly: true, 
                    decoration: const InputDecoration(
                      labelText: 'Tanggal',
                      labelStyle: TextStyle(color: Colors.greenAccent),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      suffixIcon: Icon(Icons.calendar_today, color: Colors.greenAccent),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(), 
                        lastDate: DateTime(2100),  
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: Colors.greenAccent, 
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

                  TextField(
                    controller: waktuController,
                    style: const TextStyle(color: Colors.white),
                    readOnly: true, 
                    decoration: const InputDecoration(
                      labelText: 'Waktu',
                      labelStyle: TextStyle(color: Colors.greenAccent),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      suffixIcon: Icon(Icons.access_time, color: Colors.greenAccent),
                    ),
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime ?? TimeOfDay.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: Colors.greenAccent, 
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
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () async {
                        if (namaAcaraController.text.isEmpty || tanggalController.text.isEmpty || waktuController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: const Color(0xFF3C2A21),
                              title: const Text('Peringatan', style: TextStyle(color: Colors.redAccent)),
                              content: const Text('Semua field harus diisi!', style: TextStyle(color: Colors.white)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK', style: TextStyle(color: Colors.greenAccent)),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        if (selectedDate != null && selectedTime != null) {
                          DateTime targetDateTime = DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          );

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
                                    child: const Text('OK', style: TextStyle(color: Colors.greenAccent)),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }
                        }

                        if (documentSnapshot == null) {
                          await FirebaseFirestore.instance.collection('acara_penting').add({
                            'nama_acara': namaAcaraController.text,
                            'tanggal': tanggalController.text,
                            'waktu': waktuController.text,
                          });
                        } else {
                          await FirebaseFirestore.instance.collection('acara_penting').doc(documentSnapshot.id).update({
                            'nama_acara': namaAcaraController.text,
                            'tanggal': tanggalController.text,
                            'waktu': waktuController.text,
                          });
                        }
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
        iconTheme: const IconThemeData(color: Colors.greenAccent),
      ),
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
                          child: Icon(Icons.event_note, color: Colors.greenAccent, size: 30),
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
                              icon: const Icon(Icons.edit, color: Colors.greenAccent),
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
                                        child: const Text('Batal', style: TextStyle(color: Colors.greenAccent)),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text('Hapus', style: TextStyle(color: Colors.redAccent)),
                                      ),
                                    ],
                                  ),
                                ) ?? false;

                                if (confirm) {
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
          return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}