import 'package:get/get.dart';
import '../models/pengajuan_model.dart';
import '../services/api_service.dart';
import '../utils/data_storage.dart';

class PengajuanController extends GetxController {
  var list = <Pengajuan>[].obs;
  var loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPengajuan();
  }

  Future<void> fetchPengajuan() async {
    loading.value = true;
    final userId = await DataStorage.getUserId();

    if (userId != null) {
      list.value = await ApiService.getPengajuan(userId);
    }

    loading.value = false;
  }
}
