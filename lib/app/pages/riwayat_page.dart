import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trivanox/app/pages/absen/riwayat_absen_section.dart';

import '../controllers/riwayat_absen_controller.dart';

class RiwayatPage extends GetView<RiwayatAbsenController> {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // pastikan controller sudah terinisialisasi
    final controller = Get.put(RiwayatAbsenController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Absen',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchRiwayat();
        },
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: RiwayatAbsenSection(),
        ),
      ),
    );
  }
}
