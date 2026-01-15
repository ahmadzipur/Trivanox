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

class ClockInPage extends StatefulWidget {
  const ClockInPage({super.key});

  @override
  State<ClockInPage> createState() => _ClockInPageState();
}

class _ClockInPageState extends State<ClockInPage> {
  File? _image;
  Position? _position;
  bool _loading = false;
  bool _compressing = false;

  final ImagePicker _picker = ImagePicker();

  /* ===================== FOTO ===================== */
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );

    if (picked == null) return;

    setState(() => _compressing = true);

    try {
      final userId = await DataStorage.getUserId();
      final compressed = await _compressImage(File(picked.path), userId!);

      setState(() => _image = compressed);
    } finally {
      setState(() => _compressing = false);
    }
  }

  Future<File> _compressImage(File file, int userId) async {
    final dir = await getTemporaryDirectory();

    final targetPath =
        '${dir.path}/masuk_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

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

  /* ===================== LOKASI ===================== */
  Future<void> _getLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      Get.snackbar('Error', 'GPS tidak aktif');
      throw Exception('GPS off');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Error', 'Izin lokasi ditolak permanen');
      throw Exception('Permission denied');
    }

    _position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /* ===================== SUBMIT ===================== */
  Future<void> _submit() async {
    if (_image == null) {
      Get.snackbar('Error', 'Foto wajib diambil');
      return;
    }

    setState(() => _loading = true);

    try {
      await _getLocation();
      final userId = await DataStorage.getUserId();

      final result = await ApiService.absenMasuk(
        userId: userId!,
        image: _image!,
        latitude: _position!.latitude,
        longitude: _position!.longitude,
      );

      if (result['success'] == true) {
        Get.find<AbsensiController>().loadStatus();
        Get.back();
        Get.snackbar('Sukses', result['message']);
      } else {
        Get.snackbar('Error', result['message']);
      }
    } catch (_) {}

    setState(() => _loading = false);
  }

  /* ===================== UI ===================== */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clock In',
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
              onTap: _pickImage,
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _image == null
                    ? const Center(child: Icon(Icons.camera_alt, size: 60))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: (_loading || _compressing) ? null : _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: Colors.green,
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
                  : const Icon(Icons.login, color: Colors.white),
              label: Text(
                _compressing
                    ? 'Memproses foto...'
                    : _loading
                    ? 'Mengirim...'
                    : 'Clock In',
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
