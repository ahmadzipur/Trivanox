import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/api_service.dart';
import '../utils/data_storage.dart';

class TambahPengajuanController extends GetxController {
  var jenis = "".obs;
  var kategori = "".obs;
  var kategoriList = <String>[].obs;

  var tanggalMulai = Rx<DateTime?>(null);
  var tanggalSelesai = Rx<DateTime?>(null);

  var isHalfDay = false.obs;

  var jumlahHariC = TextEditingController();
  var alasanC = TextEditingController();

  var file = Rx<File?>(null);
  var loading = false.obs;

  void setJenis(String v) {
    jenis.value = v;
    kategori.value = "";

    if (v == "cuti") {
      kategoriList.value = [
        "Cuti Bulanan",
        "Cuti Tahunan",
        "Cuti Melahirkan",
        "Cuti Khusus",
        "Cuti Penting",
      ];
    } else if (v == "izin") {
      kategoriList.value = [
        "Izin Datang Terlambat",
        "Izin Pulang Lebih Awal",
        "Izin Dinas Luar",
        "Izin Tidak Masuk Kerja",
        "Izin Keperluan Kantor",
        "Izin Keperluan Pribadi",
      ];
    } else {
      kategoriList.value = [
        "Sakit Umum",
        "Sakit dengan Bukti Medis",
        "Sakit Khusus",
        "Sakit Psikologis",
      ];
    }
  }

  void hitungHari() {
    if (tanggalMulai.value == null || tanggalSelesai.value == null) return;
    final d = tanggalSelesai.value!.difference(tanggalMulai.value!).inDays + 1;
    jumlahHariC.text = d.toString();
  }

  Future pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file.value = File(result.files.single.path!);
    }
  }

  Future submit() async {
    try {
      loading.value = true;
      debugPrint("▶ SUBMIT START");
      final userId = await DataStorage.getUserId();
      debugPrint("User ID: $userId");

      debugPrint("Jenis: ${jenis.value}");
      if (jenis.value.isEmpty) {
        Get.snackbar("Error", "Jenis pengajuan wajib dipilih");
        return;
      }
      debugPrint("Kategori: ${kategori.value}");
      if (kategori.value.isEmpty) {
        Get.snackbar("Error", "Kategori pengajuan wajib dipilih");
        return;
      }
      debugPrint("Mulai: ${tanggalMulai.value}");
      if (tanggalMulai.value == null) {
        Get.snackbar("Error", "Tanggal mulai wajib dipilih");
        return;
      }
      debugPrint("Selesai: ${tanggalSelesai.value}");
      if (tanggalSelesai.value == null) {
        Get.snackbar("Error", "Tanggal selesai wajib dipilih");
        return;
      }

      debugPrint("Jumlah hari: ${jumlahHariC.text}");
      debugPrint("Half day: ${isHalfDay.value}");
      debugPrint("Alasan: ${alasanC.text}");
      if (alasanC.text.isEmpty) {
        Get.snackbar(
          "Error",
          "Alasan harus diisi dengan jelas, jujur dan dapat dipertanggungjawabkan",
        );
        return;
      }
      debugPrint("File: ${file.value?.path}");

      final result = await ApiService.tambahPengajuan(
        idUser: userId!,
        jenis: jenis.value,
        kategori: kategori.value,
        tglMulai: tanggalMulai.value!,
        tglSelesai: tanggalSelesai.value!,
        jumlahHari: jumlahHariC.text,
        isHalfDay: isHalfDay.value,
        alasan: alasanC.text,
        file: file.value,
      );
      debugPrint("API RESPONSE: $result");

      if (result["status"] == "success") {
        debugPrint("SUBMIT SUCCESS");
        Get.back(result: true);
        Get.snackbar("Sukses", result["message"]);
      } else {
        debugPrint("SUBMIT FAILED");
        Get.snackbar("Error", result["message"]);
      }
    } catch (e) {
      debugPrint("❌ SUBMIT ERROR: $e");
      Get.snackbar("Error", "Gagal mengirim data");
    } finally {
      debugPrint("▶ SUBMIT FINISH");
      loading.value = false;
    }
  }
}
