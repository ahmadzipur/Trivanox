import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../controllers/absensi_controller.dart';
import '../../services/api_service.dart';
import '../../utils/data_storage.dart';

class ClockOutPage extends StatefulWidget {
  const ClockOutPage({super.key});

  @override
  State<ClockOutPage> createState() => _ClockOutPageState();
}

class _ClockOutPageState extends State<ClockOutPage> {
  File? _photo;
  bool _loading = false;
  bool _compressing = false;

  /// 📸 Ambil foto
  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );

    if (image == null) return;

    setState(() => _compressing = true);

    try {
      final compressed = await _compressImage(File(image.path));
      setState(() => _photo = compressed);
    } finally {
      setState(() => _compressing = false);
    }
  }

  /// 🗜️ Kompres hingga ±50KB
  Future<File> _compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/clockout_${DateTime.now().millisecondsSinceEpoch}.jpg';

    int quality = 70;
    File? result;

    do {
      final compressed = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
      );
      if (compressed == null) break;

      result = File(compressed.path);
      quality -= 10;
    } while (result.lengthSync() > 50000 && quality > 10);

    return result ?? file;
  }

  /// 📍 Ambil lokasi
  Future<Position> _getLocation() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) throw 'GPS tidak aktif';

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw 'Izin lokasi ditolak permanen';
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// 📤 Kirim data
  Future<void> _submit() async {
    if (_photo == null) {
      Get.snackbar('Perhatian', 'Foto wajib diambil');
      return;
    }

    try {
      setState(() => _loading = true);

      final position = await _getLocation();
      final userId = await DataStorage.getUserId();

      final result = await ApiService.clockOut(
        userId: userId!,
        latitude: position.latitude,
        longitude: position.longitude,
        photo: _photo!,
      );

      if (result['success'] == true) {
        Get.find<AbsensiController>().loadStatus();
        Get.back();
        Get.snackbar('Sukses', result['message']);
      } else {
        Get.snackbar('Gagal', result['message']);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Absen Pulang',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickPhoto,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _photo == null
                    ? const Center(child: Icon(Icons.camera_alt, size: 50))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_photo!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: (_loading || _compressing) ? null : _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: Colors.red,
              ),
              icon: (_loading || _compressing)
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.logout, color: Colors.white),
              label: Text(
                _compressing
                    ? 'Memproses foto...'
                    : _loading
                    ? 'Mengirim...'
                    : 'Clock Out',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
