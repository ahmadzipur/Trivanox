import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/absensi_controller.dart';
import '../controllers/riwayat_absen_controller.dart';
import '../controllers/user_controller.dart';
import '../utils/data_storage.dart';
import '../widgets/current_datetime.dart';
import 'absen/break_in_page.dart';
import 'absen/break_out_page.dart';
import 'absen/clock_in_page.dart';
import 'absen/clock_out_page.dart';
import 'absen/riwayat_absen_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _opacity = 0;
  Future<int?> userId = DataStorage.getUserId();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() => _opacity = 1);
    });
  }

  Color _statusColor(int status) {
    switch (status) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.grey;
      default:
        return Colors.red;
    }
  }

  Widget _absenButton({
    required String label,
    required IconData icon,
    required bool enabled,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: enabled ? 1 : 0.4,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: enabled ? color : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());
    final AbsensiController absensiController = Get.put(AbsensiController());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.user.value!;
        final photoUrl = 'https://ryzola.com/trivanox/${user.fotoProfile}';

        return AnimatedOpacity(
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
          opacity: _opacity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool isTablet = constraints.maxWidth >= 600;

              final double avatarSize = isTablet ? 36 : 26;
              final double nameSize = isTablet ? 28 : 24;
              final double jobSize = isTablet ? 20 : 18;
              final double companySize = isTablet ? 20 : 18;

              final EdgeInsets padding = EdgeInsets.fromLTRB(
                20,
                isTablet ? 60 : 50,
                20,
                isTablet ? 30 : 25,
              );

              return RefreshIndicator(
                onRefresh: () async {
                  // Panggil method fetch di controller
                  await controller.fetchUser(); // refresh data user
                  await absensiController.loadStatus(); // refresh status absen
                  await Get.put(
                    RiwayatAbsenController(),
                  ).fetchRiwayat(); // refresh riwayat absen
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// ================= HEADER =================
                      Container(
                        padding: padding,
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.namaCompany,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: companySize,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        style: TextStyle(
                                          fontSize: nameSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        user.jabatan.isNotEmpty
                                            ? user.jabatan
                                            : 'Karyawan',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: jobSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CircleAvatar(
                                  radius: avatarSize,
                                  backgroundColor: Colors.white,
                                  backgroundImage: user.fotoProfile.isNotEmpty
                                      ? NetworkImage(photoUrl)
                                      : null,
                                  child: user.fotoProfile.isEmpty
                                      ? const Icon(Icons.person)
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// ================= WAKTU & TANGGAL =================
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: Colors
                              .blue
                              .shade100, // Mengubah warna latar belakang menjadi biru
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// STATUS ABSEN (API)
                                Obx(() {
                                  if (absensiController.isLoading.value) {
                                    return const Text(
                                      "Memuat status...",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Status Absen",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        absensiController.label.value,
                                        style: TextStyle(
                                          color: _statusColor(
                                            absensiController.status.value,
                                          ),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  );
                                }),

                                /// JAM & TANGGAL (NON Obx)
                                const CurrentDateTime(),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Obx(() {
                          if (absensiController.isLoading.value) {
                            return const SizedBox();
                          }

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _absenButton(
                                      label: 'Clock In',
                                      icon: Icons.login,
                                      enabled: absensiController.canClockIn(),
                                      color: Colors.green,
                                      onTap: () {
                                        Get.to(() => const ClockInPage());
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _absenButton(
                                      label: 'Break Out',
                                      icon: Icons.free_breakfast,
                                      enabled: absensiController.canBreakOut(),
                                      color: Colors.orange,
                                      onTap: () {
                                        Get.to(() => const BreakOutPage());
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _absenButton(
                                      label: 'Break In',
                                      icon: Icons.work,
                                      enabled: absensiController.canBreakIn(),
                                      color: Colors.blue,
                                      onTap: () {
                                        Get.to(() => const BreakInPage());
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _absenButton(
                                      label: 'Clock Out',
                                      icon: Icons.logout,
                                      enabled: absensiController.canClockOut(),
                                      color: Colors.red,
                                      onTap: () {
                                        Get.to(() => const ClockOutPage());
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Riwayat Absen",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const RiwayatAbsenSection(),

                      /// konten berikutnya 
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
