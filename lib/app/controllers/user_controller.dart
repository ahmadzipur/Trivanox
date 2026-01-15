import 'package:get/get.dart';
import '../utils/data_storage.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import '../pages/login_page.dart';

class UserController extends GetxController {
  var isLoading = true.obs;
  var user = Rxn<UserModel>();

  @override
  void onInit() async {
    super.onInit();

    final userId = await DataStorage.getUserId();

    // Jika belum login → lempar ke Login
    if (userId == null) {
      Get.offAll(() => const LoginPage());
      return;
    }

    // Jika sudah login → ambil data user
    loadUser(userId);
  }

  Future<void> loadUser(int userId) async {
    try {
      isLoading(true);
      final data = await ApiService.fetchUser(userId);
      user.value = UserModel(data);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchUser() async {
    final userId = await DataStorage.getUserId();
    if (userId != null) {
      try {
        isLoading(true);
        final data = await ApiService.fetchUser(userId);
        user.value = UserModel(data);
      } catch (e) {
        Get.snackbar('Error', e.toString());
      } finally {
        isLoading(false);
      }
    }
  }
}
