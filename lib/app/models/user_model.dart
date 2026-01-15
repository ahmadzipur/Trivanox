class UserModel {
  final Map<String, dynamic> raw;

  UserModel(this.raw);

  String get name => raw['name'] ?? '';
  String get jabatan =>
      (raw['jabatan'] == null || raw['jabatan'].toString().isEmpty)
          ? 'Karyawan'
          : raw['jabatan'];

  String get namaCompany => raw['nama_company'] ?? '';
  String get fotoProfile => raw['foto_profile'] ?? '';
}
