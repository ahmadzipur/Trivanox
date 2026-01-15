import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../utils/data_storage.dart';

class AbsensiController extends GetxController {
  var isLoading = true.obs;
  var status = 0.obs;
  var label = 'Belum Absen'.obs;
  bool canClockIn() => status.value == 0;

  bool canBreakOut() => status.value == 1;

  bool canBreakIn() => status.value == 2;

  bool canClockOut() =>
      status.value == 1 ||
      status.value == 2 ||
      status.value == 3;


  @override
  void onInit() {
    super.onInit();
    loadStatus();
  }

  Future<void> loadStatus() async {
    try {
      isLoading(true);
      final userId = await DataStorage.getUserId();
      if (userId == null) return;

      final result = await ApiService.fetchStatusAbsen(userId);

      status.value = result['status'] ?? 0;
      label.value = result['label'] ?? 'Belum Absen';

    } catch (e) {
      debugPrint('Error status absen: $e');
      label.value = 'Gagal memuat status';
    } finally {
      isLoading(false);
    }
  }

}
