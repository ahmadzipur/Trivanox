import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trivanox/app/pages/pengajuan/detail_pengajuan_page.dart';

import '../../controllers/pengajuan_controller.dart';
import '../../models/pengajuan_model.dart';
import '../../utils/date_helper.dart';
import '../../utils/text_helper.dart';
import 'tambah_pengajuan_page.dart';

class PengajuanPage extends GetView<PengajuanController> {
  const PengajuanPage({super.key});

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

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      case 'canceled':
        return 'Dibatalkan';
      default:
        return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PengajuanController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengajuan Izin/Cuti',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // 🔹 Tombol tambah
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => TambahPengajuanPage())?.then((result) {
                      if (result == true) {
                        controller.fetchPengajuan();
                      }
                    });
                  },

                  icon: const Icon(Icons.add),
                  label: const Text(
                    "Tambah Pengajuan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 8,
                    backgroundColor: Colors.white, // biar border kelihatan
                    foregroundColor: Colors.blue, // warna teks & icon
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.blue, width: 1),
                    ),
                  ),
                ),
              ),
            ),

            // 🔹 List
            Expanded(
              child: controller.list.isEmpty
                  ? const Center(child: Text('Belum ada pengajuan'))
                  : RefreshIndicator(
                      onRefresh: () async => await controller.fetchPengajuan(),
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.list.length,
                        itemBuilder: (context, index) {
                          final Pengajuan item = controller.list[index];

                          return Card(
                            elevation: 10,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: Colors.blue,
                                width: 0.5,
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                TextHelper.capitalize(item.jenis),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Kategori: ${item.kategori}\n'
                                '${DateHelper.formatDMY(item.tanggalMulai)} s/d ${DateHelper.formatDMY(item.tanggalSelesai)}',
                              ),
                              trailing: Text(
                                _statusLabel(item.status),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: _statusColor(item.status),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                Get.to(
                                  () => DetailPengajuanPage(),
                                  arguments: item.id,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}
