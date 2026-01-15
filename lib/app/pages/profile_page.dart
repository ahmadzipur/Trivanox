import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trivanox/app/utils/text_helper.dart';

import '../controllers/profile_controller.dart';
import '../utils/data_storage.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final c = Get.put(ProfileController());
  final Map<String, String> statusPernikahanMap = {
    "Lajang": "Single",
    "Menikah": "Married",
    "Cerai": "Divorced",
    "Janda/Duda": "Widowed",
    "Berpisah": "Separated",
  };
  final Map<String, String> statusKaryawanMap = {
    "part_time": "Part Time",
    "magang": "Magang",
    "training": "Training",
    "probation": "Probation",
    "contract": "Kontrak",
    "permanent": "Karyawan Tetap",
    "lainnya": "Lainnya",
  };

  // Buat controller untuk semua TextField
  final TextEditingController nipCtrl = TextEditingController();
  final TextEditingController nikCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController nicknameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController jabatanCtrl = TextEditingController();
  final TextEditingController tempatLahirCtrl = TextEditingController();
  final TextEditingController tanggalLahirCtrl = TextEditingController();
  final TextEditingController nomorHpCtrl = TextEditingController();
  final TextEditingController alamatCtrl = TextEditingController();
  final TextEditingController postalCodeCtrl = TextEditingController();
  final TextEditingController tanggalMasukCtrl = TextEditingController();
  final TextEditingController tanggalKeluarCtrl = TextEditingController();
  final TextEditingController userStatusCtrl = TextEditingController();
  final TextEditingController npwpCtrl = TextEditingController();
  final TextEditingController bpjsTkCtrl = TextEditingController();
  final TextEditingController bpjsKesCtrl = TextEditingController();
  final TextEditingController bankCtrl = TextEditingController();
  final TextEditingController nomorRekeningCtrl = TextEditingController();

  @override
  void dispose() {
    nipCtrl.dispose();
    nikCtrl.dispose();
    nameCtrl.dispose();
    nicknameCtrl.dispose();
    emailCtrl.dispose();
    jabatanCtrl.dispose();
    tempatLahirCtrl.dispose();
    tanggalLahirCtrl.dispose();
    nomorHpCtrl.dispose();
    alamatCtrl.dispose();
    postalCodeCtrl.dispose();
    tanggalMasukCtrl.dispose();
    tanggalKeluarCtrl.dispose();
    userStatusCtrl.dispose();
    npwpCtrl.dispose();
    bpjsTkCtrl.dispose();
    bpjsKesCtrl.dispose();
    bankCtrl.dispose();
    nomorRekeningCtrl.dispose();
    super.dispose();
  }

  void fillControllers() {
    final user = c.profile.value!;
    nipCtrl.text = user.nip ?? '-';
    nikCtrl.text = user.nik ?? '-';
    nameCtrl.text = user.name;
    nicknameCtrl.text = user.namaPanggilan ?? '';
    emailCtrl.text = user.email;
    jabatanCtrl.text = user.jabatan;
    tempatLahirCtrl.text = user.tempatLahir ?? '';
    tanggalLahirCtrl.text = formatTanggal(user.tanggalLahir);
    nomorHpCtrl.text = user.nomorHp ?? '';
    alamatCtrl.text = user.alamat ?? '';
    postalCodeCtrl.text = user.postalCode ?? '';
    tanggalMasukCtrl.text = formatTanggal(user.tanggalMasuk);
    tanggalKeluarCtrl.text = formatTanggal(user.tanggalKeluar);
    userStatusCtrl.text = TextHelper.capitalize(user.userStatus);
    npwpCtrl.text = user.npwp ?? '';
    bpjsTkCtrl.text = user.bpjsTk ?? '';
    bpjsKesCtrl.text = user.bpjsKes ?? '';
    bankCtrl.text = user.rekeningBank ?? '';
    nomorRekeningCtrl.text = user.nomorRekening ?? '';
  }

  String formatTanggal(String? dbDate) {
    if (dbDate == null || dbDate.isEmpty || dbDate == "0000-00-00") {
      return "00-00-0000";
    }
    try {
      DateTime dt = DateTime.parse(dbDate);
      return DateFormat('dd-MM-yyyy').format(dt);
    } catch (_) {
      return "00-00-0000";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil Karyawan",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Obx(() {
        if (c.isLoading.value)
          return const Center(child: CircularProgressIndicator());
        if (c.profile.value == null)
          return const Center(child: Text("Data tidak ditemukan"));

        fillControllers();
        final user = c.profile.value!;
        final photoUrl =
            user.fotoProfile != null && user.fotoProfile!.isNotEmpty
            ? 'https://ryzola.com/trivanox/${user.fotoProfile}'
            : null;

        return RefreshIndicator(
          onRefresh: () async {
            c.fetchProfile();
            c.photo.value = null;
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // FOTO
                Obx(() {
                  ImageProvider? img;
                  if (c.photo.value != null) {
                    img = FileImage(c.photo.value!);
                  } else if (photoUrl != null) {
                    img = NetworkImage(photoUrl);
                  }

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: c.pickPhoto,
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: img,
                          child: img == null
                              ? const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text("Tap untuk ganti foto"),
                    ],
                  );
                }),
                const SizedBox(height: 20),

                // IDENTITAS
                section("Identitas", [
                  input(
                    "Nomor Identitas",
                    nikCtrl,
                    onChanged: (v) => user.nik = v,
                  ),
                  inputReadOnly(
                    "Nomor ID Karyawan",
                    nipCtrl,
                    onChanged: (v) => user.nip = v,
                  ),
                  input(
                    "Nama Lengkap",
                    nameCtrl,
                    onChanged: (v) => user.name = v,
                  ),
                  input(
                    "Nama Panggilan",
                    nicknameCtrl,
                    onChanged: (v) => user.namaPanggilan = v,
                  ),
                  input(
                    "Tempat Lahir",
                    tempatLahirCtrl,
                    onChanged: (v) => user.tempatLahir = v,
                  ),
                  dateInput(
                    label: "Tanggal Lahir",
                    controller: tanggalLahirCtrl,
                    initialValue: user.tanggalLahir,
                    onChanged: (valDb) {
                      user.tanggalLahir = valDb;
                    },
                    context: context,
                  ),
                  const SizedBox(height: 12),
                  dropdownInput("Jenis Kelamin", user.jenisKelamin, [
                    "Laki-laki",
                    "Perempuan",
                  ], (v) => user.jenisKelamin = v),
                  dropdownInput(
                    "Status Pernikahan",
                    statusPernikahanMap.entries
                        .firstWhere(
                          (e) => e.value == user.statusPernikahan,
                          orElse: () => const MapEntry("Lajang", "Single"),
                        )
                        .key,
                    statusPernikahanMap.keys.toList(),
                    (label) {
                      user.statusPernikahan = statusPernikahanMap[label]!;
                    },
                  ),

                  dropdownInput("Agama", user.agama, [
                    "Islam",
                    "Kristen",
                    "Katolik",
                    "Hindu",
                    "Buddha",
                    "Konghucu",
                    "Lainnya",
                  ], (v) => user.agama = v),
                ]),

                // KONTAK & ALAMAT
                section("Kontak & Alamat", [
                  input("Email", emailCtrl, onChanged: (v) => user.email = v),
                  input(
                    "Nomor HP",
                    nomorHpCtrl,
                    onChanged: (v) => user.nomorHp = v,
                  ),
                  input(
                    "Alamat",
                    alamatCtrl,
                    onChanged: (v) => user.alamat = v,
                    maxLines: 3,
                  ),

                  // Dropdown berantai Provinsi→Desa
                  Obx(
                    () => DropdownButtonFormField<int>(
                      value: user.provinceId,
                      decoration: const InputDecoration(labelText: "Provinsi"),
                      items: c.provinces
                          .map(
                            (p) => DropdownMenuItem<int>(
                              value: p['id'],
                              child: Text(p['name']),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        user.provinceId = val;
                        user.regencyId = null;
                        user.districtId = null;
                        user.villageId = null;
                        c.fetchRegencies(val!);
                      },
                    ),
                  ),
                  Obx(
                    () => DropdownButtonFormField<int>(
                      value: user.regencyId,
                      decoration: const InputDecoration(labelText: "Kabupaten"),
                      items: c.regencies
                          .map(
                            (r) => DropdownMenuItem<int>(
                              value: r['id'],
                              child: Text(r['name']),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        user.regencyId = val;
                        user.districtId = null;
                        user.villageId = null;
                        c.fetchDistricts(val!);
                      },
                    ),
                  ),
                  Obx(
                    () => DropdownButtonFormField<int>(
                      value: user.districtId,
                      decoration: const InputDecoration(labelText: "Kecamatan"),
                      items: c.districts
                          .map(
                            (d) => DropdownMenuItem<int>(
                              value: d['id'],
                              child: Text(d['name']),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        user.districtId = val;
                        user.villageId = null;
                        c.fetchVillages(val!);
                      },
                    ),
                  ),
                  Obx(
                    () => DropdownButtonFormField<int>(
                      value: user.villageId,
                      decoration: const InputDecoration(labelText: "Desa"),
                      items: c.villages
                          .map(
                            (v) => DropdownMenuItem<int>(
                              value: v['id'],
                              child: Text(v['name']),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => user.villageId = val,
                    ),
                  ),
                  const SizedBox(height: 20),

                  input(
                    "Kode Pos",
                    postalCodeCtrl,
                    onChanged: (v) => user.postalCode = v,
                  ),
                ]),

                // KEPEGAWAIAN
                section("Kepegawaian", [
                  dateInput(
                    label: "Tanggal Masuk",
                    controller: tanggalMasukCtrl,
                    initialValue: user.tanggalMasuk,
                    onChanged: (valDb) {
                      user.tanggalMasuk = valDb;
                    },
                    context: context,
                  ),
                  const SizedBox(height: 12),
                  dateInput(
                    label: "Tanggal Keluar",
                    controller: tanggalKeluarCtrl,
                    initialValue: user.tanggalKeluar,
                    onChanged: (valDb) {
                      user.tanggalKeluar = valDb;
                    },
                    context: context,
                  ),
                  const SizedBox(height: 12),
                  input(
                    "Jabatan",
                    jabatanCtrl,
                    onChanged: (v) => user.jabatan = v,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: userStatusCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Status Karyawan",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ]),
                // BANK & BPJS
                section("Bank & BPJS", [
                  input("NPWP", npwpCtrl, onChanged: (v) => user.npwp = v),
                  input(
                    "BPJS TK",
                    bpjsTkCtrl,
                    onChanged: (v) => user.bpjsTk = v,
                  ),
                  input(
                    "BPJS KES",
                    bpjsKesCtrl,
                    onChanged: (v) => user.bpjsKes = v,
                  ),
                  input(
                    "Bank",
                    bankCtrl,
                    onChanged: (v) => user.rekeningBank = v,
                  ),
                  input(
                    "Nomor Rekening",
                    nomorRekeningCtrl,
                    onChanged: (v) => user.nomorRekening = v,
                  ),
                ]),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      "Simpan Profil",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () => c.updateProfile(user),
                  ),
                ),

                const SizedBox(height: 56),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      'Logout',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () async {
                      await DataStorage.logout();
                      Get.offAll(() => const LoginPage());
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ===== HELPERS =====
  Widget section(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget input(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    int maxLines = 1,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget inputReadOnly(
    String label,
    TextEditingController controller, {
    bool readOnly = true,
    int maxLines = 1,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget dateInput({
    required String label,
    required TextEditingController controller,
    String? initialValue,
    Function(String)? onChanged,
    required BuildContext context,
  }) {
    if (controller.text.isEmpty) controller.text = formatTanggal(initialValue);

    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onTap: () async {
        DateTime initialDate;
        try {
          final parts = controller.text.split('-');
          initialDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        } catch (_) {
          initialDate = DateTime.now();
        }

        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          controller.text = DateFormat('dd-MM-yyyy').format(picked);
          if (onChanged != null)
            onChanged(DateFormat('yyyy-MM-dd').format(picked));
        }
      },
    );
  }

  Widget dropdownInput(
    String label,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: items.contains(value) ? value : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
