import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../utils/data_storage.dart';
import '../widgets/bottom_nav.dart';

class LoginController extends GetxController {
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  Future<void> login() async {
    if (emailC.text.isEmpty || passwordC.text.isEmpty) {
      Get.snackbar('Error', 'Email dan password wajib diisi');
      return;
    }

    try {
      isLoading(true);

      final response =
          await ApiService.login(emailC.text, passwordC.text);

      if (response['success'] == true) {
        final userId = response['user']['id'];

        await DataStorage.saveUserId(userId);

        Get.offAll(() => const BottomNav());
      } else {
        Get.snackbar('Login Gagal', response['message']);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
