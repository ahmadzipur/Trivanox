import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/profile_model.dart';
import '../services/api_service.dart';
import '../utils/data_storage.dart';

class ProfileController extends GetxController {
  var profile = Rx<ProfileModel?>(null);
  Rx<File?> photo = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  // Dropdown lists
  var provinces = <Map<String, dynamic>>[].obs;
  var regencies = <Map<String, dynamic>>[].obs;
  var districts = <Map<String, dynamic>>[].obs;
  var villages = <Map<String, dynamic>>[].obs;

  // Loading state
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    fetchProvinces();
  }

  void fetchProfile() async {
    isLoading.value = true;
    final userId = await DataStorage.getUserId();
    if (userId == null) return;
    try {
      var data = await ApiService.fetchUser(userId); // API PHP yang return JSON
      profile.value = ProfileModel.fromJson(data);
      if (profile.value!.provinceId != null)
        fetchRegencies(profile.value!.provinceId!);
      if (profile.value!.regencyId != null)
        fetchDistricts(profile.value!.regencyId!);
      if (profile.value!.districtId != null)
        fetchVillages(profile.value!.districtId!);
    } finally {
      isLoading.value = false;
    }
  }

  void fetchProvinces() async {
    var data = await ApiService.getProvinces();
    provinces.value = data;
  }

  void fetchRegencies(int provinceId) async {
    var data = await ApiService.getRegencies(provinceId);
    regencies.value = data;
  }

  void fetchDistricts(int regencyId) async {
    var data = await ApiService.getDistricts(regencyId);
    districts.value = data;
  }

  void fetchVillages(int districtId) async {
    var data = await ApiService.getVillages(districtId);
    villages.value = data;
  }

  void updateProfile(ProfileModel updated) async {
    isLoading.value = true;
    try {
      if (photo.value != null) {
        // ⬅️ PAKAI MULTIPART
        await ApiService.updateProfileMultipart(updated, photo.value!);
      } else {
        // ⬅️ PAKAI JSON (LAMA)
        await ApiService.updateProfileJson(updated.toJson());
      }

      profile.value = updated;
      Get.snackbar('Sukses', 'Data berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Error', e.toString());
      debugPrint('ERROR: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // function untuk pick photo (menggunakan image_picker)
  void pickPhoto() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // atau ImageSource.camera
      imageQuality: 80,
    );

    if (pickedFile != null) {
      photo.value = File(pickedFile.path);
    }
  }
}
