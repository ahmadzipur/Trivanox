import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/riwayat_absen_controller.dart';
import '../../utils/date_helper.dart';
import 'detail_absen_page.dart';

class RiwayatAbsenSection extends GetView<RiwayatAbsenController> {
  const RiwayatAbsenSection({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RiwayatAbsenController());

    return Obx(() {
      if (controller.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.list.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Belum ada riwayat absen'),
        );
      }

      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.list.length,
          itemBuilder: (context, index) {
            final item = controller.list[index];

            return FutureBuilder(
              future: Future.delayed(Duration(milliseconds: index * 600)),
              builder: (context, snapshot) {
                final visible =
                    snapshot.connectionState == ConnectionState.done;

                return AnimatedSlide(
                  offset: visible ? Offset.zero : const Offset(0.25, 0),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  child: AnimatedOpacity(
                    opacity: visible ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Get.to(() => DetailAbsenPage(data: item));
                      },
                      child: Card(
                        color: Colors.cyan.shade50,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tanggal: ${DateHelper.formatDMY(item.tanggal)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Masuk ${item.jamMasuk} • Pulang ${item.jamPulang}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    });
  }
}
