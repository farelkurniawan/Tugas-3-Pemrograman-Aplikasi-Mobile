import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AcaraPentingScreen extends StatelessWidget {
  const AcaraPentingScreen({super.key});

  // Fungsi untuk menampilkan form input (Tambah/Edit Data) di Bottom Sheet
  void _showForm(BuildContext context, [DocumentSnapshot? documentSnapshot]) {
    final TextEditingController namaAcaraController = TextEditingController();
    final TextEditingController tanggalController = TextEditingController();

    // Jika documentSnapshot tidak null, berarti kita sedang mode 'Edit'
    if (documentSnapshot != null) {
      namaAcaraController.text = documentSnapshot['nama_acara'];
      tanggalController.text = documentSnapshot['tanggal'];
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF3C2A21), // Sesuai tema
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            // Menghindari form tertutup keyboard
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
                  labelText: 'Nama Acara (Misal: Survey Gedung)',
                  labelStyle: TextStyle(color: Colors.greenAccent),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                ),
              ),
              TextField(
                controller: tanggalController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Tanggal (Misal: 12 Nov 2026)',
                  labelStyle: TextStyle(color: Colors.greenAccent),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black, // Warna teks tombol
                  ),
                  onPressed: () async {
                    final String namaAcara = namaAcaraController.text;
                    final String tanggal = tanggalController.text;

                    if (namaAcara.isNotEmpty && tanggal.isNotEmpty) {
                      if (documentSnapshot == null) {
                        // CREATE: Menambah data baru ke Firestore
                        await FirebaseFirestore.instance.collection('acara_penting').add({
                          'nama_acara': namaAcara,
                          'tanggal': tanggal,
                        });
                      } else {
                        // UPDATE: Mengubah data yang sudah ada
                        await FirebaseFirestore.instance.collection('acara_penting').doc(documentSnapshot.id).update({
                          'nama_acara': namaAcara,
                          'tanggal': tanggal,
                        });
                      }
                      // Tutup form setelah selesai
                      if (context.mounted) Navigator.of(context).pop();
                    }
                  },
                  child: Text(documentSnapshot == null ? 'Simpan' : 'Update'),
                ),
              )
            ],
          ),
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
      // READ: Menampilkan data secara real-time dari Firestore
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
                return Card(
                  color: Colors.black45,
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: ListTile(
                    title: Text(documentSnapshot['nama_acara'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(documentSnapshot['tanggal'], style: const TextStyle(color: Colors.white70)),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Tombol EDIT
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.greenAccent),
                            onPressed: () => _showForm(context, documentSnapshot),
                          ),
                          // Tombol DELETE
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () async {
                              // Konfirmasi sebelum menghapus
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
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          // Loading indicator saat mengambil data
          return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
        },
      ),
      // Tombol FAB untuk menambah data
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}