import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/pengajuan_model.dart';
import '../models/profile_model.dart';
import '../models/riwayat_absen_model.dart';

class ApiService {
  static const String baseUrl = 'https://ryzola.com/trivanox';

  // GET USER PROFILE
  static Future<Map<String, dynamic>> fetchUser(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api-get-user-profile.php?id_user=$userId'),
    );

    final json = jsonDecode(response.body);
    debugPrint('FETCH USER: ${response.body}');
    print("📡 HTTP STATUS: ${response.statusCode}");

    if (json['success'] == true) {
      return json['data'];
    } else {
      throw Exception(json['message'] ?? 'Gagal mengambil data user');
    }
  }

  // LOGIN
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api-login.php'),
      body: {'email': email, 'password': password},
    );

    return jsonDecode(response.body);
  }

  // CEK STATUS ABSEN
  static Future<Map<String, dynamic>> fetchStatusAbsen(int userId) async {
    final uri = Uri.parse('$baseUrl/api-cek-status-absen.php?id_user=$userId');

    final response = await http.get(uri);

    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('BODY: ${response.body}');

    final json = jsonDecode(response.body);

    if (json['success'] == true) {
      return json;
    } else {
      throw Exception(json['message'] ?? 'API error');
    }
  }

  static Future<Map<String, dynamic>> absenMasuk({
    required int userId,
    required File image,
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse('$baseUrl/api-absen-masuk.php');

    var request = http.MultipartRequest('POST', uri);
    request.fields['user_id'] = userId.toString();
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();

    request.files.add(await http.MultipartFile.fromPath('foto', image.path));

    final response = await request.send();
    final res = await http.Response.fromStream(response);

    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> mulaiIstirahat({
    required int userId,
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse('${baseUrl}/api-mulai-istirahat.php');

    final response = await http.post(
      uri,
      body: {
        'user_id': userId.toString(),
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      },
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> selesaiIstirahat({
    required int userId,
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse('${baseUrl}/api-selesai-istirahat.php');

    final response = await http.post(
      uri,
      body: {
        'user_id': userId.toString(),
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      },
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> clockOut({
    required int userId,
    required double latitude,
    required double longitude,
    required File photo,
  }) async {
    final uri = Uri.parse('${baseUrl}/api-absen-pulang.php');

    final request = http.MultipartRequest('POST', uri)
      ..fields['user_id'] = userId.toString()
      ..fields['latitude'] = latitude.toString()
      ..fields['longitude'] = longitude.toString()
      ..files.add(await http.MultipartFile.fromPath('foto', photo.path));

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    return jsonDecode(respStr);
  }

  static Future<List<RiwayatAbsen>> getRiwayatAbsen(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api-riwayat-absen.php?id_user=$userId'),
    );

    debugPrint("STATUS: ${response.statusCode}");
    debugPrint("BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Server error (${response.statusCode})");
    }

    final Map<String, dynamic> json = jsonDecode(response.body);

    if (json['success'] == true && json['data'] is List) {
      return (json['data'] as List)
          .map((e) => RiwayatAbsen.fromJson(e))
          .toList();
    }

    return [];
  }

  static Future<List<Pengajuan>> getPengajuan(int userId) async {
    final response = await http.get(
      Uri.parse('${baseUrl}/api-get-pengajuan.php?id_user=$userId'),
    );

    final json = jsonDecode(response.body);

    print('PENGAJUAN RESPONSE: $json'); // DEBUG

    if (json['success'] == true && json['data'] is List) {
      return (json['data'] as List).map((e) => Pengajuan.fromJson(e)).toList();
    }
    return [];
  }

  static Future<Map<String, dynamic>> tambahPengajuan({
    required int idUser,
    required String jenis,
    required String kategori,
    required DateTime tglMulai,
    required DateTime tglSelesai,
    required String jumlahHari,
    required bool isHalfDay,
    required String alasan,
    File? file,
  }) async {
    final uri = Uri.parse("${baseUrl}/api-tambah-pengajuan.php");

    var request = http.MultipartRequest("POST", uri);

    // ===============================
    // FIELD YANG DIPAKAI PHP
    // ===============================
    request.fields.addAll({
      "id_user": idUser.toString(),
      "jenis": jenis,
      "kategori": kategori,
      "tanggal_mulai": _formatDate(tglMulai), // yyyy-MM-dd
      "tanggal_selesai": _formatDate(tglSelesai),
      "jumlah_hari": jumlahHari,
      "is_half_day": isHalfDay ? "1" : "0",
      "alasan": alasan,
    });

    // ===============================
    // FILE UPLOAD (OPTIONAL)
    // ===============================
    if (file != null) {
      request.files.add(
        await http.MultipartFile.fromPath("file_pendukung", file.path),
      );
    }

    // ===============================
    // SEND REQUEST
    // ===============================
    final response = await request.send();
    final body = await response.stream.bytesToString();

    final json = jsonDecode(body);

    print('TAMBAH PENGAJUAN RESPONSE: $json'); // DEBUG

    if (response.statusCode != 200) {
      throw "Server error (${response.statusCode})";
    }

    return json;
  }

  static String _formatDate(DateTime d) {
    final y = d.year.toString();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return "$y-$m-$day";
  }

  static Future<Map<String, dynamic>> saveProfile({
    required int idUser,
    required String name,
    required String email,
    required String nik,
    required String nomorHP,
    required String alamat,
    required String jenisKelamin,
    required String statusPernikahan,
    File? fotoProfile,
  }) async {
    final uri = Uri.parse("$baseUrl/api-simpan-profile.php");

    var request = http.MultipartRequest("POST", uri);

    // ===============================
    // FIELD (STRING ONLY)
    // ===============================
    request.fields.addAll({
      "id_user": idUser.toString(),
      "name": name,
      "email": email,
      "nik": nik,
      "nomor_hp": nomorHP,
      "alamat": alamat,
      "jenis_kelamin": jenisKelamin,
      "status_pernikahan": statusPernikahan,
    });

    // ===============================
    // FILE UPLOAD (OPTIONAL)
    // ===============================
    if (fotoProfile != null) {
      request.files.add(
        await http.MultipartFile.fromPath("foto_profile", fotoProfile.path),
      );
    }

    // ===============================
    // SEND REQUEST
    // ===============================
    final response = await request.send();
    final body = await response.stream.bytesToString();

    final json = jsonDecode(body);

    print('SAVE PROFILE RESPONSE: $json'); // DEBUG

    if (response.statusCode != 200) {
      throw Exception("Server error (${response.statusCode})");
    }

    return json;
  }

  // ===============================
  // GET PROVINCES
  // ===============================
  static Future<List<Map<String, dynamic>>> getProvinces() async {
    final uri = Uri.parse('$baseUrl/api-get-provinces.php');
    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    if (json['success'] == true && json['data'] is List) {
      return List<Map<String, dynamic>>.from(json['data']);
    } else {
      throw Exception(json['message'] ?? 'Gagal mengambil provinsi');
    }
  }

  // ===============================
  // GET REGENCIES
  // ===============================
  static Future<List<Map<String, dynamic>>> getRegencies(int provinceId) async {
    final uri = Uri.parse(
      '$baseUrl/api-get-regencies.php?province_id=$provinceId',
    );
    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    if (json['success'] == true && json['data'] is List) {
      return List<Map<String, dynamic>>.from(json['data']);
    } else {
      throw Exception(json['message'] ?? 'Gagal mengambil kabupaten');
    }
  }

  // ===============================
  // GET DISTRICTS
  // ===============================
  static Future<List<Map<String, dynamic>>> getDistricts(int regencyId) async {
    final uri = Uri.parse(
      '$baseUrl/api-get-districts.php?regency_id=$regencyId',
    );
    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    if (json['success'] == true && json['data'] is List) {
      return List<Map<String, dynamic>>.from(json['data']);
    } else {
      throw Exception(json['message'] ?? 'Gagal mengambil kecamatan');
    }
  }

  // ===============================
  // GET VILLAGES
  // ===============================
  static Future<List<Map<String, dynamic>>> getVillages(int districtId) async {
    final uri = Uri.parse(
      '$baseUrl/api-get-villages.php?district_id=$districtId',
    );
    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    if (json['success'] == true && json['data'] is List) {
      return List<Map<String, dynamic>>.from(json['data']);
    } else {
      throw Exception(json['message'] ?? 'Gagal mengambil desa');
    }
  }

  // ===============================
  // UPDATE PROFILE
  // ===============================
  static Future<Map<String, dynamic>> updateProfileJson(
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse("$baseUrl/api-simpan-profile.php");
    var request = http.MultipartRequest("POST", uri);

    // STRING FIELDS
    data.forEach((key, value) {
      if (value != null && value is! File) {
        request.fields[key] = value.toString();
      }
    });

    // FILE FIELDS
    data.forEach((key, value) async {
      if (value != null && value is File) {
        request.files.add(await http.MultipartFile.fromPath(key, value.path));
      }
    });

    final response = await request.send();
    final body = await response.stream.bytesToString();
    final json = jsonDecode(body);

    print('UPDATE PROFILE JSON RESPONSE: $json');

    if (response.statusCode != 200) {
      throw Exception("Server error (${response.statusCode})");
    }
    return json;
  }

  static Future<void> updateProfileMultipart(
    ProfileModel user,
    File photo,
  ) async {
    final uri = Uri.parse('$baseUrl/api-simpan-profile.php');

    final request = http.MultipartRequest('POST', uri);

    // =====================
    // FIELD BIASA
    // =====================
    request.fields.addAll(
      user.toJson().map((k, v) => MapEntry(k, v?.toString() ?? '')),
    );

    // =====================
    // FILE FOTO
    // =====================
    request.files.add(
      await http.MultipartFile.fromPath(
        'foto_profile', // HARUS SAMA DENGAN PHP
        photo.path,
      ),
    );

    final response = await request.send();
    final body = await response.stream.bytesToString();

    final json = jsonDecode(body);
    if (json['status'] != true) {
      throw Exception(json['message'] ?? 'Gagal update profil');
    }
  }
}
