import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/riwayat_absen_model.dart';
import '../services/api_service.dart';
import '../utils/data_storage.dart';

class RiwayatAbsenController extends GetxController {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  final list = <RiwayatAbsen>[].obs;
  final loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRiwayat();
  }

  Future<void> fetchRiwayat() async {
    loading.value = true;

    final userId = await DataStorage.getUserId();
    if (userId == null) {
      loading.value = false;
      return;
    }

    try {
      loading.value = true;
      list.value = await ApiService.getRiwayatAbsen(userId);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> setData(List<RiwayatAbsen> data) async {
    for (int i = 0; i < data.length; i++) {
      list.add(data[i]);

      listKey.currentState?.insertItem(
        i,
        duration: const Duration(milliseconds: 400),
      );

      await Future.delayed(const Duration(milliseconds: 80));
    }
  }
}
