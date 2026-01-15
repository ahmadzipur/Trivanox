class ProfileModel {
  int id;
  int? idCompany;
  String? nip;
  String? nik;
  String name;
  String email;
  String role;
  String jabatan;
  String? fotoProfile;
  String? namaPanggilan;
  String? tempatLahir;
  String? tanggalLahir;
  String? jenisKelamin;
  String? statusPernikahan;
  String? agama;
  String? nomorHp;
  String? alamat;
  int? provinceId;
  int? regencyId;
  int? districtId;
  int? villageId;
  String? postalCode;
  String? tanggalMasuk;
  String? tanggalKeluar;
  String? userStatus;
  int? idDivision;
  int? idBranch;
  String? rekeningBank;
  String? nomorRekening;
  String? npwp;
  String? bpjsTk;
  String? bpjsKes;

  ProfileModel({
    required this.id,
    this.idCompany,
    this.nip,
    this.nik,
    required this.name,
    required this.email,
    required this.role,
    required this.jabatan,
    this.fotoProfile,
    this.namaPanggilan,
    this.tempatLahir,
    this.tanggalLahir,
    this.jenisKelamin,
    this.statusPernikahan,
    this.agama,
    this.nomorHp,
    this.alamat,
    this.provinceId,
    this.regencyId,
    this.districtId,
    this.villageId,
    this.postalCode,
    this.tanggalMasuk,
    this.tanggalKeluar,
    this.userStatus,
    this.idDivision,
    this.idBranch,
    this.rekeningBank,
    this.nomorRekening,
    this.npwp,
    this.bpjsTk,
    this.bpjsKes,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      idCompany: json['id_company'],
      nip: json['nip'],
      nik: json['nik'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      jabatan: json['jabatan'],
      fotoProfile: json['foto_profile'],
      namaPanggilan: json['nama_panggilan'],
      tempatLahir: json['tempat_lahir'],
      tanggalLahir: json['tanggal_lahir'],
      jenisKelamin: json['jenis_kelamin'],
      statusPernikahan: json['status_pernikahan'],
      agama: json['agama'],
      nomorHp: json['nomor_hp'],
      alamat: json['alamat'],
      provinceId: json['province_id'],
      regencyId: json['regency_id'],
      districtId: json['district_id'],
      villageId: json['village_id'],
      postalCode: json['postal_code'],
      tanggalMasuk: json['tanggal_masuk'],
      tanggalKeluar: json['tanggal_keluar'],
      userStatus: json['user_status'],
      idDivision: json['id_division'],
      idBranch: json['id_branch'],
      rekeningBank: json['rekening_bank'],
      nomorRekening: json['nomor_rekening'],
      npwp: json['npwp'],
      bpjsTk: json['bpjs_tk'],
      bpjsKes: json['bpjs_kes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_company': idCompany,
      'nip': nip,
      'nik': nik,
      'name': name,
      'email': email,
      'role': role,
      'jabatan': jabatan,
      'foto_profile': fotoProfile,
      'nama_panggilan': namaPanggilan,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir,
      'jenis_kelamin': jenisKelamin,
      'status_pernikahan': statusPernikahan,
      'agama': agama,
      'nomor_hp': nomorHp,
      'alamat': alamat,
      'province_id': provinceId,
      'regency_id': regencyId,
      'district_id': districtId,
      'village_id': villageId,
      'postal_code': postalCode,
      'tanggal_masuk': tanggalMasuk,
      'tanggal_keluar': tanggalKeluar,
      'user_status': userStatus,
      'id_division': idDivision,
      'id_branch': idBranch,
      'rekening_bank': rekeningBank,
      'nomor_rekening': nomorRekening,
      'npwp': npwp,
      'bpjs_tk': bpjsTk,
      'bpjs_kes': bpjsKes,
    };
  }
}
