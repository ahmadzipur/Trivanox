import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trivanox/app/utils/text_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/pengajuan_controller.dart';
import '../../utils/date_helper.dart';

class DetailPengajuanPage extends GetView<PengajuanController> {
  const DetailPengajuanPage({super.key});

  void _openFile(String fileUrl) async {
    final url = Uri.parse(fileUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'canceled':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int idPengajuan = Get.arguments as int;
    final controller = Get.put(PengajuanController());

    final data = controller.list.firstWhereOrNull((e) => e.id == idPengajuan);

    if (data == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Detail Pengajuan',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(child: Text('Data pengajuan tidak ditemukan')),
      );
    }
    final fileUrl = 'https://ryzola.com/trivanox/${data.filePendukung}';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Pengajuan',
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
          _item('Jenis', TextHelper.capitalize(data.jenis)),
          _item('Kategori', data.kategori),
          _item(
            'Tanggal',
            '${DateHelper.formatDMY(data.tanggalMulai)} s/d ${DateHelper.formatDMY(data.tanggalSelesai)}',
          ),
          _item('Jumlah Hari', data.jumlahHari.toString()),
          _item('Half Day', data.isHalfDay ? 'Ya' : 'Tidak'),
          _item('Alasan', data.alasan),
          const SizedBox(height: 16),

          // File Pendukung
          if (data.filePendukung != null && data.filePendukung!.isNotEmpty)
            GestureDetector(
              onTap: () => _openFile(fileUrl!),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.attach_file, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        data.filePendukung!.split('/').last,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const Icon(Icons.open_in_new, color: Colors.blue),
                  ],
                ),
              ),
            )
          else
            const Text('Tidak ada file pendukung'),

          const SizedBox(height: 24),

          _item(
            'Status',
            TextHelper.capitalize(data.status),
            color: _statusColor(data.status),
          ),
          if (data.status.toLowerCase() == 'approved') ...[
            _item('Disetujui oleh', data.approvedByName ?? '-'),
            _item(
              'Tanggal persetujuan',
              data.approvedAt != null
                  ? DateHelper.formatDateTime(data.approvedAt!)
                  : '-',
            ),
          ],
          if (data.status.toLowerCase() == 'rejected') ...[
            _item('Alasan ditolak', data.rejectedReason ?? '-'),
          ],
          const SizedBox(height: 16),
          _item('Dibuat oleh', data.createdByName ?? '-'),
          _item('Tanggal dibuat', DateHelper.formatDateTime(data.createdAt)),
          _item(
            'Terakhir diperbarui',
            DateHelper.formatDateTime(data.updatedAt),
          ),
        ],
      ),
    );
  }

  Widget _item(String title, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text('$title')),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
