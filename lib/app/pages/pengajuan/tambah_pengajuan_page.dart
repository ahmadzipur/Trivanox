import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trivanox/app/utils/date_helper.dart';

import '../../controllers/tambah_pengajuan_controller.dart';

class TambahPengajuanPage extends StatelessWidget {
  final c = Get.put(TambahPengajuanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah Pengajuan",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              DropdownButtonFormField(
                value: c.jenis.value.isEmpty ? null : c.jenis.value,
                decoration: const InputDecoration(labelText: "Jenis"),
                items: ["cuti", "izin", "sakit"]
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.capitalize!),
                      ),
                    )
                    .toList(),
                onChanged: (v) => c.setJenis(v!),
              ),

              const SizedBox(height: 10),

              Obx(
                () => DropdownButtonFormField(
                  value: c.kategori.value.isEmpty ? null : c.kategori.value,
                  decoration: const InputDecoration(labelText: "Kategori"),
                  items: c.kategoriList
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => c.kategori.value = v!,
                ),
              ),

              const SizedBox(height: 10),

              _datePicker("Tanggal Mulai", c.tanggalMulai, c),
              _datePicker("Tanggal Selesai", c.tanggalSelesai, c),

              Obx(
                () => SwitchListTile(
                  value: c.isHalfDay.value,
                  title: const Text("Setengah Hari"),
                  onChanged: (v) => c.isHalfDay.value = v,
                ),
              ),

              TextFormField(
                controller: c.jumlahHariC,
                decoration: const InputDecoration(labelText: "Jumlah Hari"),
                readOnly: true,
              ),

              TextFormField(
                controller: c.alasanC,
                decoration: const InputDecoration(labelText: "Alasan"),
                maxLines: 3,
              ),

              const SizedBox(height: 15),

              Obx(
                () => OutlinedButton.icon(
                  onPressed: c.pickFile,
                  icon: const Icon(Icons.upload_file),
                  label: Text(
                    c.file.value == null ? "Upload File" : "File Dipilih",
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Obx(
                () => ElevatedButton(
                  onPressed: c.loading.value ? null : c.submit,
                  child: c.loading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Ajukan"),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _datePicker(
    String label,
    Rx<DateTime?> date,
    TambahPengajuanController c,
  ) {
    return Obx(
      () => ListTile(
        title: Text(
          date.value == null
              ? label
              : "${label}: ${DateHelper.formatDate(date.value!).toString().substring(0, 10)}",
        ),
        trailing: const Icon(Icons.date_range),
        onTap: () async {
          final d = await showDatePicker(
            context: Get.context!,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (d != null) {
            date.value = d;
            c.hitungHari();
          }
        },
      ),
    );
  }
}
