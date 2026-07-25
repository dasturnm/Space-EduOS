// Lokasi: lib/features/akademik/kurikulum/models/modul_model.dart
// -----------------------------------------------------------------------------

// 1. MODUL MODEL (The Specific Target/Content)
// -----------------------------------------------------------------------------
class ModulModel {
  final String? id;
  final String levelId;
  final String namaModul;
  final String tipe;
  final int targetPertemuan;
  final double targetAmount;
  final String? silabus;
  final List<SilabusItemModel> silabusContent;
  final List<String> materiSilabus;
  final bool isSystemGenerated;
  final String jenisMetrik;
  final String? mulaiKoordinatJuz;
  final String? akhirKoordinatJuz;
  final int surahIdStart;
  final int surahIdEnd;
  final int mulaiHalaman;
  final int akhirHalaman;
  final int targetInternalAkhir;
  final int ayahStart;
  final int ayahEnd;
  final int totalBaris;
  final int totalSurah;
  final double totalHalaman;
  final double totalJuz;
  final double kkm;
  final String silabusSource;
  final bool isStrict;
  final bool isAllowBelowTarget;
  final bool isAccumulated;
  final bool isSingleBurden;
  final String manzilType;
  final double manzilAmount;
  final String targetAmountUnit;
  final bool isPlottingActive;
  final bool showManzilInDashboard;
  final bool isMurojaah;

  final bool isExamRequired;
  final String evaluationType;
  final double tasmiVolume;
  final String tasmiUnit;
  final bool isCumulativeTasmi;
  final int tasmiRange;
  final bool useRatingScale;
  final bool isTasmiRequired;
  final bool isTasmiSekaliDuduk;
  final bool isReverseOrder;

  final Map<String, dynamic>? sertifikasiSettings;
  final List<TargetMetrikModel> targetMetrik;
  final List<ModulEvaluasiTemplateModel> evaluasiTemplates;
  final int urutan;

  int get bobotItqon => (sertifikasiSettings?['itqon']?['bobot'] as num?)?.toInt() ?? 0;
  int get bobotMakhraj => (sertifikasiSettings?['makhraj']?['bobot'] as num?)?.toInt() ?? 0;
  int get bobotTajwid => (sertifikasiSettings?['tajwid']?['bobot'] as num?)?.toInt() ?? 0;
  int get bobotNada => (sertifikasiSettings?['nada']?['bobot'] as num?)?.toInt() ?? 0;
  int get bobotAdab => (sertifikasiSettings?['adab']?['bobot'] as num?)?.toInt() ?? 0;
  int get bobotPenampilan => (sertifikasiSettings?['penampilan']?['bobot'] as num?)?.toInt() ?? 0;
  int get bobotTebakSurah => (sertifikasiSettings?['tebak_surah']?['bobot'] as num?)?.toInt() ?? 0;

  ModulModel({
    this.id,
    required this.levelId,
    required this.namaModul,
    required this.tipe,
    this.targetPertemuan = 30,
    this.targetAmount = 0.0,
    this.silabus,
    this.silabusContent = const [],
    this.materiSilabus = const [],
    this.isSystemGenerated = false,
    this.jenisMetrik = 'SURAH',
    this.mulaiKoordinatJuz,
    this.akhirKoordinatJuz,
    this.surahIdStart = 0,
    this.surahIdEnd = 0,
    this.mulaiHalaman = 0,
    this.akhirHalaman = 0,
    this.targetInternalAkhir = 0,
    this.ayahStart = 0,
    this.ayahEnd = 0,
    this.totalBaris = 0,
    this.totalSurah = 0,
    this.totalHalaman = 0.0,
    this.totalJuz = 0.0,
    this.kkm = 80,
    this.silabusSource = 'mushaf',
    this.isStrict = false,
    this.isAllowBelowTarget = true,
    this.isAccumulated = false,
    this.isSingleBurden = true,
    this.manzilType = 'fixed',
    this.manzilAmount = 0.0,
    this.targetAmountUnit = 'HALAMAN',
    this.isPlottingActive = false,
    this.showManzilInDashboard = true,
    this.isMurojaah = false,
    this.isExamRequired = false,
    this.evaluationType = 'checklist',
    this.tasmiVolume = 1.0,
    this.tasmiUnit = 'JUZ',
    this.isCumulativeTasmi = false,
    this.tasmiRange = 5,
    this.useRatingScale = false,
    this.isTasmiRequired = false,
    this.isTasmiSekaliDuduk = true,
    this.isReverseOrder = false,
    this.sertifikasiSettings,
    this.targetMetrik = const [],
    this.evaluasiTemplates = const [],
    this.urutan = 0,
  });

  List<String> get extractedMateriList {
    if (silabusContent.isNotEmpty) {
      return silabusContent.map((e) => e.materi).where((m) => m.trim().isNotEmpty).toList();
    }
    return materiSilabus;
  }

  int calculateTotalMeetings() {
    if (totalBaris <= 0 || targetAmount <= 0) {
      return targetPertemuan;
    }
    return (totalBaris / targetAmount).ceil();
  }

  factory ModulModel.fromJson(Map<String, dynamic> json) => ModulModel(
    id: (json['id'] == null || json['id'].toString() == 'null') ? null : json['id'].toString(),
    levelId: json['level_id']?.toString() ?? '',
    namaModul: json['nama_modul']?.toString() ?? '',
    tipe: json['tipe']?.toString() ?? 'HAFALAN',
    targetPertemuan: (json['target_pertemuan'] as num?)?.toInt() ?? 30,
    targetAmount: (json['target_amount'] as num?)?.toDouble() ?? 0.0,
    silabus: json['silabus']?.toString(),
    silabusContent: (json['silabus_content'] is List)
        ? (json['silabus_content'] as List)
        .whereType<Map<String, dynamic>>()
        .map((x) => SilabusItemModel.fromJson(x))
        .toList()
        : const [],
    materiSilabus: (json['materi_silabus'] is List)
        ? List<String>.from(json['materi_silabus'])
        : const [],
    isSystemGenerated: json['is_system_generated'] == true,
    jenisMetrik: json['jenis_metrik']?.toString() ?? 'HALAMAN',
    mulaiKoordinatJuz: json['mulai_koordinat_juz']?.toString() ?? json['mulai_koordinat']?.toString(),
    akhirKoordinatJuz: json['akhir_koordinat_juz']?.toString() ?? json['akhir_koordinat']?.toString(),
    surahIdStart: (json['surah_id_start'] as num?)?.toInt() ?? (json['surah_id'] as num?)?.toInt() ?? 0,
    surahIdEnd: (json['surah_id_end'] as num?)?.toInt() ?? 0,
    mulaiHalaman: (json['mulai_halaman'] as num?)?.toInt() ?? 0,
    akhirHalaman: (json['akhir_halaman'] as num?)?.toInt() ?? 0,
    targetInternalAkhir: (json['target_internal_akhir'] as num?)?.toInt() ?? 0,
    ayahStart: (json['ayah_start'] as num?)?.toInt() ?? 0,
    ayahEnd: (json['ayah_end'] as num?)?.toInt() ?? 0,
    totalBaris: (json['total_baris'] as num?)?.toInt() ?? 0,
    totalSurah: (json['total_surah'] as num?)?.toInt() ?? 0,
    totalHalaman: (json['total_halaman'] as num?)?.toDouble() ?? 0.0,
    totalJuz: (json['total_juz'] as num?)?.toDouble() ?? 0.0,
    kkm: (json['kkm'] as num?)?.toDouble() ?? 80.0,
    silabusSource: json['silabus_source']?.toString() ?? 'mushaf',
    isStrict: json['is_strict'] == true,
    isAllowBelowTarget: json['is_allow_below_target'] ?? true,
    isAccumulated: json['is_accumulated'] == true,
    isSingleBurden: json['is_single_burden'] ?? true,
    manzilType: json['manzil_type']?.toString() ?? 'fixed',
    manzilAmount: (json['manzil_amount'] as num?)?.toDouble() ?? 0.0,
    targetAmountUnit: json['target_amount_unit']?.toString() ?? 'HALAMAN',
    isPlottingActive: json['is_plotting_active'] == true,
    showManzilInDashboard: json['show_manzil_in_dashboard'] ?? true,
    isMurojaah: json['is_murojaah'] == true,
    isExamRequired: json['is_exam_required'] == true,
    evaluationType: json['evaluation_type']?.toString() ?? 'checklist',
    tasmiVolume: (json['tasmi_volume'] as num?)?.toDouble() ?? 1.0,
    tasmiUnit: json['tasmi_unit']?.toString() ?? 'JUZ',
    isCumulativeTasmi: json['is_cumulative_tasmi'] == true,
    tasmiRange: (json['tasmi_range'] as num?)?.toInt() ?? 5,
    useRatingScale: json['use_rating_scale'] == true,
    isTasmiRequired: json['is_tasmi_required'] == true || (json['is_tasmi_required'] as bool? ?? false),
    isTasmiSekaliDuduk: json['is_tasmi_sekali_duduk'] ?? true,
    isReverseOrder: json['is_reverse_order'] == true,
    sertifikasiSettings: json['sertifikasi_settings'] as Map<String, dynamic>?,
    targetMetrik: (json['target_metrik_kurikulum'] is List)
        ? (json['target_metrik_kurikulum'] as List)
        .whereType<Map<String, dynamic>>()
        .map((x) => TargetMetrikModel.fromJson(x))
        .toList()
        : const [],
    evaluasiTemplates: (json['modul_evaluasi_template'] is List)
        ? (json['modul_evaluasi_template'] as List)
        .whereType<Map<String, dynamic>>()
        .map((x) => ModulEvaluasiTemplateModel.fromJson(x))
        .toList()
        : const [],
    urutan: (json['urutan'] as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    if (id != null && id!.isNotEmpty) 'id': id,
    'level_id': levelId,
    'nama_modul': namaModul,
    'tipe': tipe,
    'target_pertemuan': targetPertemuan,
    'target_amount': targetAmount,
    'silabus': silabus,
    'silabus_content': List<dynamic>.from(silabusContent.map((x) => x.toJson())),
    'materi_silabus': materiSilabus,
    'is_system_generated': isSystemGenerated,
    'jenis_metrik': jenisMetrik,
    'mulai_koordinat_juz': mulaiKoordinatJuz,
    'akhir_koordinat_juz': akhirKoordinatJuz,
    'surah_id_start': (() {
      final s = silabusSource == 'mushaf' && surahIdStart == 0 ? 1 : surahIdStart;
      final e = silabusSource == 'mushaf' && surahIdEnd == 0 ? 114 : surahIdEnd;
      return s < e ? s : e;
    })(),
    'surah_id_end': (() {
      final s = silabusSource == 'mushaf' && surahIdStart == 0 ? 1 : surahIdStart;
      final e = silabusSource == 'mushaf' && surahIdEnd == 0 ? 114 : surahIdEnd;
      return s < e ? e : s;
    })(),
    'mulai_halaman': (mulaiHalaman > 0 && akhirHalaman > 0) ? (mulaiHalaman < akhirHalaman ? mulaiHalaman : akhirHalaman) : mulaiHalaman,
    'akhir_halaman': (mulaiHalaman > 0 && akhirHalaman > 0) ? (mulaiHalaman < akhirHalaman ? akhirHalaman : mulaiHalaman) : akhirHalaman,
    'target_internal_akhir': targetInternalAkhir,
    'ayah_start': (() {
      final sSurah = silabusSource == 'mushaf' && surahIdStart == 0 ? 1 : surahIdStart;
      final eSurah = silabusSource == 'mushaf' && surahIdEnd == 0 ? 114 : surahIdEnd;
      if (sSurah < eSurah) return ayahStart;
      if (sSurah > eSurah) return ayahEnd;
      return ayahStart <= ayahEnd ? ayahStart : ayahEnd;
    })(),
    'ayah_end': (() {
      final sSurah = silabusSource == 'mushaf' && surahIdStart == 0 ? 1 : surahIdStart;
      final eSurah = silabusSource == 'mushaf' && surahIdEnd == 0 ? 114 : surahIdEnd;
      if (sSurah < eSurah) return ayahEnd;
      if (sSurah > eSurah) return ayahStart;
      return ayahStart <= ayahEnd ? ayahEnd : ayahStart;
    })(),
    'total_baris': totalBaris,
    'total_surah': totalSurah,
    'total_halaman': totalHalaman,
    'total_juz': totalJuz,
    'kkm': kkm,
    'silabus_source': silabusSource,
    'is_strict': isStrict,
    'is_allow_below_target': isAllowBelowTarget,
    'is_accumulated': isAccumulated,
    'is_single_burden': isSingleBurden,
    'manzil_type': manzilType,
    'manzil_amount': manzilAmount,
    'target_amount_unit': targetAmountUnit,
    'is_plotting_active': isPlottingActive,
    'show_manzil_in_dashboard': showManzilInDashboard,
    'is_murojaah': isMurojaah,
    'is_exam_required': isExamRequired,
    'evaluation_type': evaluationType,
    'tasmi_volume': tasmiVolume,
    'tasmi_unit': tasmiUnit,
    'is_cumulative_tasmi': isCumulativeTasmi,
    'tasmi_range': tasmiRange,
    'use_rating_scale': useRatingScale,
    'is_tasmi_required': isTasmiRequired,
    'is_tasmi_sekali_duduk': isTasmiSekaliDuduk,
    'is_reverse_order': isReverseOrder,
    'sertifikasi_settings': sertifikasiSettings,
    'modul_evaluasi_template': List<dynamic>.from(evaluasiTemplates.map((x) => x.toJson())),
    'urutan': urutan,
  };

  ModulModel copyWith({
    String? id,
    String? levelId,
    String? namaModul,
    String? tipe,
    int? targetPertemuan,
    double? targetAmount,
    String? silabus,
    List<SilabusItemModel>? silabusContent,
    List<String>? materiSilabus,
    bool? isSystemGenerated,
    String? jenisMetrik,
    String? mulaiKoordinatJuz,
    String? akhirKoordinatJuz,
    int? surahIdStart,
    int? surahIdEnd,
    int? mulaiHalaman,
    int? akhirHalaman,
    int? targetInternalAkhir,
    int? ayahStart,
    int? ayahEnd,
    int? totalBaris,
    int? totalSurah,
    double? totalHalaman,
    double? totalJuz,
    double? kkm,
    String? silabusSource,
    bool? isStrict,
    bool? isAllowBelowTarget,
    bool? isAccumulated,
    bool? isSingleBurden,
    String? manzilType,
    double? manzilAmount,
    String? targetAmountUnit,
    bool? isPlottingActive,
    bool? showManzilInDashboard,
    bool? isMurojaah,
    bool? isExamRequired,
    String? evaluationType,
    double? tasmiVolume,
    String? tasmiUnit,
    bool? isCumulativeTasmi,
    int? tasmiRange,
    bool? useRatingScale,
    bool? isTasmiRequired,
    bool? isTasmiSekaliDuduk,
    bool? isReverseOrder,
    Map<String, dynamic>? sertifikasiSettings,
    List<TargetMetrikModel>? targetMetrik,
    List<ModulEvaluasiTemplateModel>? evaluasiTemplates,
    int? urutan,
  }) {
    return ModulModel(
      id: id ?? this.id,
      levelId: levelId ?? this.levelId,
      namaModul: namaModul ?? this.namaModul,
      tipe: tipe ?? this.tipe,
      targetPertemuan: targetPertemuan ?? this.targetPertemuan,
      targetAmount: targetAmount ?? this.targetAmount,
      silabus: silabus ?? this.silabus,
      silabusContent: silabusContent ?? this.silabusContent,
      materiSilabus: materiSilabus ?? this.materiSilabus,
      isSystemGenerated: isSystemGenerated ?? this.isSystemGenerated,
      jenisMetrik: jenisMetrik ?? this.jenisMetrik,
      mulaiKoordinatJuz: mulaiKoordinatJuz ?? this.mulaiKoordinatJuz,
      akhirKoordinatJuz: akhirKoordinatJuz ?? this.akhirKoordinatJuz,
      surahIdStart: surahIdStart ?? this.surahIdStart,
      surahIdEnd: surahIdEnd ?? this.surahIdEnd,
      mulaiHalaman: mulaiHalaman ?? this.mulaiHalaman,
      akhirHalaman: akhirHalaman ?? this.akhirHalaman,
      targetInternalAkhir: targetInternalAkhir ?? this.targetInternalAkhir,
      ayahStart: ayahStart ?? this.ayahStart,
      ayahEnd: ayahEnd ?? this.ayahEnd,
      totalBaris: totalBaris ?? this.totalBaris,
      totalSurah: totalSurah ?? this.totalSurah,
      totalHalaman: totalHalaman ?? this.totalHalaman,
      totalJuz: totalJuz ?? this.totalJuz,
      kkm: kkm ?? this.kkm,
      silabusSource: silabusSource ?? this.silabusSource,
      isStrict: isStrict ?? this.isStrict,
      isAllowBelowTarget: isAllowBelowTarget ?? this.isAllowBelowTarget,
      isAccumulated: isAccumulated ?? this.isAccumulated,
      isSingleBurden: isSingleBurden ?? this.isSingleBurden,
      manzilType: manzilType ?? this.manzilType,
      manzilAmount: manzilAmount ?? this.manzilAmount,
      targetAmountUnit: targetAmountUnit ?? this.targetAmountUnit,
      isPlottingActive: isPlottingActive ?? this.isPlottingActive,
      showManzilInDashboard: showManzilInDashboard ?? this.showManzilInDashboard,
      isMurojaah: isMurojaah ?? this.isMurojaah,
      isExamRequired: isExamRequired ?? this.isExamRequired,
      evaluationType: evaluationType ?? this.evaluationType,
      tasmiVolume: tasmiVolume ?? this.tasmiVolume,
      tasmiUnit: tasmiUnit ?? this.tasmiUnit,
      isCumulativeTasmi: isCumulativeTasmi ?? this.isCumulativeTasmi,
      tasmiRange: tasmiRange ?? this.tasmiRange,
      useRatingScale: useRatingScale ?? this.useRatingScale,
      isTasmiRequired: isTasmiRequired ?? this.isTasmiRequired,
      isTasmiSekaliDuduk: isTasmiSekaliDuduk ?? this.isTasmiSekaliDuduk,
      isReverseOrder: isReverseOrder ?? this.isReverseOrder,
      sertifikasiSettings: sertifikasiSettings ?? this.sertifikasiSettings,
      targetMetrik: targetMetrik ?? this.targetMetrik,
      evaluasiTemplates: evaluasiTemplates ?? this.evaluasiTemplates,
      urutan: urutan ?? this.urutan,
    );
  }
}

// 2. SUPPORTING MODELS (Silabus & Target Metrik)
// -----------------------------------------------------------------------------
class SilabusItemModel {
  final int pertemuan;
  final String materi;
  final String? keterangan;

  SilabusItemModel({
    required this.pertemuan,
    required this.materi,
    this.keterangan,
  });

  factory SilabusItemModel.fromJson(Map<String, dynamic> json) => SilabusItemModel(
    pertemuan: (json['pertemuan'] as num?)?.toInt() ?? 0,
    materi: json['materi']?.toString() ?? '',
    keterangan: json['keterangan']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'pertemuan': pertemuan,
    'materi': materi,
    'keterangan': keterangan,
  };
}

class TargetMetrikModel {
  final String? id;
  final String modulId;
  final String jenisMetrik;
  final String satuan;
  final String mulai;
  final String akhir;
  final double kkm;

  TargetMetrikModel({
    this.id,
    required this.modulId,
    this.jenisMetrik = 'JUZ',
    required this.satuan,
    required this.mulai,
    required this.akhir,
    this.kkm = 80.0,
  });

  factory TargetMetrikModel.fromJson(Map<String, dynamic> json) => TargetMetrikModel(
    id: (json['id'] == null || json['id'].toString() == 'null') ? null : json['id'].toString(),
    modulId: json['modul_id']?.toString() ?? '',
    jenisMetrik: json['jenis_metrik']?.toString() ?? 'JUZ',
    satuan: json['satuan']?.toString() ?? '',
    mulai: json['mulai']?.toString() ?? '',
    akhir: json['akhir']?.toString() ?? '',
    kkm: (json['kkm'] as num?)?.toDouble() ?? 80.0,
  );

  Map<String, dynamic> toJson() => {
    if (id != null && id!.trim().isNotEmpty) 'id': id,
    'modul_id': (modulId.trim().isEmpty) ? null : modulId,
    'jenis_metrik': jenisMetrik,
    'satuan': satuan,
    'mulai': mulai,
    'akhir': akhir,
    'kkm': kkm,
  };

  TargetMetrikModel copyWith({
    String? id,
    String? modulId,
    String? jenisMetrik,
    String? satuan,
    String? mulai,
    String? akhir,
    double? kkm,
  }) {
    return TargetMetrikModel(
      id: id ?? this.id,
      modulId: modulId ?? this.modulId,
      jenisMetrik: jenisMetrik ?? this.jenisMetrik,
      satuan: satuan ?? this.satuan,
      mulai: mulai ?? this.mulai,
      akhir: akhir ?? this.akhir,
      kkm: kkm ?? this.kkm,
    );
  }
}

// -----------------------------------------------------------------------------
// 3. NESTED MODEL: TEMPLATE EVALUASI SILABUS INTERNAL (Admin Template)
// -----------------------------------------------------------------------------
class ModulEvaluasiTemplateModel {
  final String? id;
  final String lembagaId;
  final String modulId;
  final String namaMateri;
  final String indikatorKelulusan;

  ModulEvaluasiTemplateModel({
    this.id,
    required this.lembagaId,
    required this.modulId,
    required this.namaMateri,
    this.indikatorKelulusan = '',
  });

  factory ModulEvaluasiTemplateModel.fromJson(Map<String, dynamic> json) => ModulEvaluasiTemplateModel(
    id: json['id']?.toString(),
    lembagaId: json['lembaga_id']?.toString() ?? '',
    modulId: json['modul_id']?.toString() ?? '',
    namaMateri: json['nama_materi']?.toString() ?? '',
    indikatorKelulusan: json['bobot']?.toString() ?? json['indikator_kelulusan']?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {
    if (id != null && id!.trim().isNotEmpty) 'id': id,
    'lembaga_id': (lembagaId.trim().isEmpty) ? null : lembagaId,
    'modul_id': (modulId.trim().isEmpty) ? null : modulId,
    'nama_materi': namaMateri,
    'bobot': double.tryParse(indikatorKelulusan) ?? 100.0,
  };

  ModulEvaluasiTemplateModel copyWith({
    String? id,
    String? lembagaId,
    String? modulId,
    String? namaMateri,
    String? indikatorKelulusan,
  }) {
    return ModulEvaluasiTemplateModel(
      id: id ?? this.id,
      lembagaId: lembagaId ?? this.lembagaId,
      modulId: modulId ?? this.modulId,
      namaMateri: namaMateri ?? this.namaMateri,
      indikatorKelulusan: indikatorKelulusan ?? this.indikatorKelulusan,
    );
  }
}