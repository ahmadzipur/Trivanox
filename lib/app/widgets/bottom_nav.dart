import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nav_controller.dart';
import '../pages/home_page.dart';
import '../pages/pengajuan/pengajuan_page.dart';
import '../pages/profile_page.dart';
import '../pages/riwayat_page.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final NavController controller = Get.put(NavController());

    final pages = [
      const HomePage(),
      const PengajuanPage(),
      const RiwayatPage(),
      ProfilePage(),
    ];

    return Obx(() => Scaffold(
          body: pages[controller.index.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.index.value,
            onTap: controller.changeIndex,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.assignment), label: 'Pengajuan'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), label: 'Riwayat'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profil'),
            ],
          ),
        ));
  }
}
