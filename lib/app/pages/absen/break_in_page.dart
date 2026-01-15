import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../controllers/absensi_controller.dart';
import '../../services/api_service.dart';
import '../../utils/data_storage.dart';

class BreakInPage extends StatefulWidget {
  const BreakInPage({super.key});

  @override
  State<BreakInPage> createState() => _BreakInPageState();
}

class _BreakInPageState extends State<BreakInPage> {
  bool _loading = false;

  Future<Position> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw 'GPS tidak aktif';

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

  Future<void> _submit() async {
    try {
      setState(() => _loading = true);

      final position = await _getLocation();
      final userId = await DataStorage.getUserId();

      final result = await ApiService.selesaiIstirahat(
        userId: userId!,
        latitude: position.latitude,
        longitude: position.longitude,
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
          'Selesai Istirahat',
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
            const Icon(Icons.work, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              'Apakah Anda sudah selesai istirahat?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: Colors.green,
              ),
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Selesai Istirahat',
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
