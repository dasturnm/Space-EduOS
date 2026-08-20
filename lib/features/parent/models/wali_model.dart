class WaliModel {
  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final String? lembagaId;
  final List<String> anakList;

  WaliModel({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    this.lembagaId,
    required this.anakList,
  });

  factory WaliModel.fromJson(Map<String, dynamic> json) {
    List<String> children = [];
    if (json['student_guardians'] != null) {
      for (var sg in json['student_guardians']) {
        if (sg['siswa'] != null && sg['siswa']['nama_lengkap'] != null) {
          children.add(sg['siswa']['nama_lengkap'].toString());
        }
      }
    }

    return WaliModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      lembagaId: json['lembaga_id'],
      anakList: children,
    );
  }
}
