import 'package:get/get.dart';

class NavController extends GetxController {
  var index = 0.obs;

  void changeIndex(int i) {
    index.value = i;
  }
}
