import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/riwayat_absen_model.dart';
import '../../utils/date_helper.dart';

class DetailAbsenPage extends StatefulWidget {
  final RiwayatAbsen data;

  const DetailAbsenPage({super.key, required this.data});

  @override
  State<DetailAbsenPage> createState() => _DetailAbsenPageState();
}

class _DetailAbsenPageState extends State<DetailAbsenPage> {
  static const String baseUrl = 'https://ryzola.com/trivanox/uploads/absensi/';

  void _openMap(double lat, double lng) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _openImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: InteractiveViewer(child: Image.network(imageUrl)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Absen',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _item('Tanggal', DateHelper.formatDMY(data.tanggal)),
          _item('Jam Masuk', data.jamMasuk),
          _item('Mulai Istirahat', data.jamMulaiIstirahat),
          _item('Selesai Istirahat', data.jamSelesaiIstirahat),
          _item('Jam Pulang', data.jamPulang),

          const SizedBox(height: 24),

          _photoSection(context, title: 'Foto Masuk', photo: data.fotoMasuk),
          const SizedBox(height: 32),

          _photoSection(context, title: 'Foto Pulang', photo: data.fotoPulang),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: (data.latMasuk != null && data.lngMasuk != null)
                ? () => _openMap(data.latMasuk!, data.lngMasuk!)
                : null,
            icon: const Icon(Icons.map),
            label: const Text('Lihat Lokasi Masuk di Maps'),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: (data.latPulang != null && data.lngPulang != null)
                ? () => _openMap(data.latPulang!, data.lngPulang!)
                : null,
            icon: const Icon(Icons.map),
            label: const Text('Lihat Lokasi Pulang di Maps'),
          ),
          const SizedBox(height: 56),
        ],
      ),
    );
  }

  Widget _photoSection(
    BuildContext context, {
    required String title,
    String? photo,
  }) {
    if (photo == null || photo.isEmpty) {
      return Text('$title: Tidak ada foto');
    }

    final imageUrl = '$baseUrl$photo';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _openImage(context, imageUrl),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 180,
                child: Center(child: Icon(Icons.broken_image)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _item(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Text(
            value ?? '-',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
