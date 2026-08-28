// Lokasi: lib/features/akademik/kurikulum/models/evaluation_kriteria_model.dart

class EvaluationKriteria {
  final String id;
  final String aspek;
  final String indikator;
  final double nilai;

  EvaluationKriteria({
    required this.id,
    required this.aspek,
    required this.indikator,
    this.nilai = 0.0,
  });

  factory EvaluationKriteria.fromJson(Map<String, dynamic> json) {
    return EvaluationKriteria(
      id: (json['id'] == null || json['id'].toString() == 'null') ? '' : json['id'].toString(),
      aspek: (json['aspek'] ?? json['aspect'])?.toString() ?? '',
      indikator: (json['indikator'] ?? json['indicator'])?.toString() ?? '',
      nilai: ((json['nilai'] ?? json['score']) as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'aspek': aspek,
      'indikator': indikator,
      'nilai': nilai,
    };
  }

  EvaluationKriteria copyWith({
    String? id,
    String? aspek,
    String? indikator,
    double? nilai,
  }) {
    return EvaluationKriteria(
      id: id ?? this.id,
      aspek: aspek ?? this.aspek,
      indikator: indikator ?? this.indikator,
      nilai: nilai ?? this.nilai,
    );
  }
}