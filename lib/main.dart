import 'package:flutter/material.dart';

void main() {
  runApp(const CatatanHarianApp());
}

class CatatanHarianApp extends StatelessWidget {
  const CatatanHarianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catatan Harian',
      initialRoute: '/',
      routes: {
        '/': (context) => const DaftarCatatan(),
        '/tambah': (context) => const TambahCatatan(),
        '/detail': (context) => const DetailCatatan(),
      },
    );
  }
}

class Catatan {
  final String judul;
  final String isi;
  final String tanggal;

  const Catatan({
    required this.judul,
    required this.isi,
    required this.tanggal,
  });
}

// Menggunakan List biasa (bukan const) agar bisa di-insert dan di-remove saat aplikasi berjalan
final List<Catatan> daftarCatatan = [
  const Catatan(
    judul: 'Belajar Flutter',
    isi: 'Mempelajari widget dasar seperti Text, Column, dan Container.',
    tanggal: '2024-05-20',
  ),
  const Catatan(
    judul: 'Tugas Data Struktur',
    isi: 'Kerjakan soal stack dan queue pada modul 3.',
    tanggal: '2024-05-21',
  ),
  const Catatan(
    judul: 'Olahraga Pagi',
    isi: 'Jogging selama 30 menit di taman kampus.',
    tanggal: '2024-05-22',
  ),
];

class DaftarCatatan extends StatefulWidget {
  const DaftarCatatan({super.key});

  @override
  State<DaftarCatatan> createState() => _DaftarCatatanState();
}

class _DaftarCatatanState extends State<DaftarCatatan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Harian'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: daftarCatatan.length,
        itemBuilder: (context, index) {
          final c = daftarCatatan[index];
          return ListTile(
            leading: const Icon(
              Icons.note_alt_outlined,
              color: Colors.indigo,
            ),
            title: Text(c.judul),
            subtitle: Text(c.tanggal),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await Navigator.pushNamed(
                context,
                '/detail',
                arguments: c,
              );
              // Refresh tampilan setelah kembali dari halaman detail (misal ada data yang dihapus)
              setState(() {});
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.pushNamed(context, '/tambah');
          // Refresh tampilan setelah kembali dari halaman tambah catatan
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TambahCatatan extends StatefulWidget {
  const TambahCatatan({super.key});

  @override
  State<TambahCatatan> createState() => _TambahCatatanState();
}

class _TambahCatatanState extends State<TambahCatatan> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _isiController = TextEditingController();

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  void _simpanCatatan() {
    if (_formKey.currentState!.validate()) {
      final tanggalHariIni = DateTime.now().toIso8601String().substring(0, 10);
      final catatanBaru = Catatan(
        judul: _judulController.text.trim(),
        isi: _isiController.text.trim(),
        tanggal: tanggalHariIni,
      );

      setState(() {
        daftarCatatan.insert(0, catatanBaru);
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan berhasil disimpan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _isiController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Isi Catatan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit_note),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Isi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _simpanCatatan,
                icon: const Icon(Icons.save),
                label: const Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailCatatan extends StatelessWidget {
  const DetailCatatan({super.key});

  @override
  Widget build(BuildContext context) {
    final c = ModalRoute.of(context)!.settings.arguments as Catatan;

    return Scaffold(
      appBar: AppBar(
        title: Text(c.judul),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Hapus Catatan',
            onPressed: () {
              daftarCatatan.remove(c);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Catatan dihapus')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.indigo,
                ),
                const SizedBox(width: 8),
                Text(
                  c.tanggal,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              c.isi,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}