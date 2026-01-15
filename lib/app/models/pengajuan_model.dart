class Pengajuan {
  final int id;
  final int idUser;
  final int idCompany;
  final int idDivision;
  final int idBranch;
  final String jenis;
  final String kategori;
  final String tanggalMulai;
  final String tanggalSelesai;
  final int jumlahHari;
  final bool isHalfDay;
  final String alasan;
  final String? filePendukung;
  final String status; 
  final String? approvedBy;
  final String? approvedByName;
  final DateTime? approvedAt;
  final String? rejectedReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;
  final String? createdByName;
  final String? updatedBy;
  final String? updatedByName;

  Pengajuan({
    required this.id,
    required this.idUser,
    required this.idCompany,
    required this.idDivision,
    required this.idBranch,
    required this.jenis,
    required this.kategori,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.jumlahHari,
    required this.isHalfDay,
    required this.alasan,
    this.filePendukung,
    required this.status,
    this.approvedBy,
    this.approvedByName,
    this.approvedAt,
    this.rejectedReason,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.createdByName,
    this.updatedBy,
    this.updatedByName,
  });

  factory Pengajuan.fromJson(Map<String, dynamic> json) {
    return Pengajuan(
      id: json['id'],
      idUser: json['id_user'],
      idCompany: json['id_company'],
      idDivision: json['id_division'] ?? 0,
      idBranch: json['id_branch'] ?? 0,
      jenis: json['jenis'] ?? '',
      kategori: json['kategori'] ?? '',
      tanggalMulai: json['tanggal_mulai'],
      tanggalSelesai: json['tanggal_selesai'],
      jumlahHari: json['jumlah_hari'] ?? 0,
      isHalfDay: json['is_half_day'] == 1,
      alasan: json['alasan'] ?? '',
      filePendukung: json['file_pendukung'],
      status: (json['status'] ?? 'pending').toString().toLowerCase(),
      approvedBy: json['approved_by'].toString(),
      approvedByName: json['approved_by_name'].toString(),
      approvedAt: json['approved_at'] != null ? DateTime.parse(json['approved_at']) : null,
      rejectedReason: json['rejected_reason'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      createdBy: json['created_by'].toString(),
      createdByName: json['created_by_name'].toString(),
      updatedBy: json['updated_by'].toString(),
      updatedByName: json['updated_by_name'].toString(),
    );
  }
}
