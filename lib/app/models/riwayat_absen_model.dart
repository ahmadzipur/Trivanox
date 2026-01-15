class RiwayatAbsen {
  final int id;
  final String tanggal;
  final String jamMasuk;
  final String jamMulaiIstirahat;
  final String jamSelesaiIstirahat;
  final String jamPulang;

  final String? fotoMasuk;
  final String? fotoPulang;

  final double? latMasuk;
  final double? lngMasuk;
  final double? latPulang;
  final double? lngPulang;

  RiwayatAbsen({
    required this.id,
    required this.tanggal,
    required this.jamMasuk,
    required this.jamMulaiIstirahat,
    required this.jamSelesaiIstirahat,
    required this.jamPulang,
    this.fotoMasuk,
    this.fotoPulang,
    this.latMasuk,
    this.lngMasuk,
    this.latPulang,
    this.lngPulang,
  });

  factory RiwayatAbsen.fromJson(Map<String, dynamic> json) {
  return RiwayatAbsen(
    id: int.parse(json['id'].toString()),
    tanggal: json['tanggal'] ?? '-',
    jamMasuk: json['jam_masuk'] ?? '-',
    jamMulaiIstirahat: json['jam_mulai_istirahat'] ?? '-',
    jamSelesaiIstirahat: json['jam_selesai_istirahat'] ?? '-',
    jamPulang: json['jam_pulang'] ?? '-',

    fotoMasuk: json['foto_masuk'],
    fotoPulang: json['foto_pulang'],

    latMasuk: double.tryParse(json['latitude_masuk']?.toString() ?? ''),
    lngMasuk: double.tryParse(json['longitude_masuk']?.toString() ?? ''),
    latPulang: double.tryParse(json['latitude_pulang']?.toString() ?? ''),
    lngPulang: double.tryParse(json['longitude_pulang']?.toString() ?? ''),
  );
}

}
