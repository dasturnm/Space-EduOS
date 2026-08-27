import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'analytics_provider.g.dart';

class TopStudent {
  final String id;
  final String name;
  final double totalAchieved;

  TopStudent({
    required this.id,
    required this.name,
    required this.totalAchieved,
  });
}

class AnalyticsState {
  final List<TopStudent> topStudents;
  final Map<int, Map<int, int>> heatmapData;

  AnalyticsState({
    this.topStudents = const [],
    this.heatmapData = const {},
  });
}

@riverpod
class AnalyticsDashboardNotifier extends _$AnalyticsDashboardNotifier {
  @override
  FutureOr<AnalyticsState> build(String organizationId) async {
    return fetchAnalyticsData(organizationId);
  }

  Future<AnalyticsState> fetchAnalyticsData(String organizationId) async {
    final supabase = Supabase.instance.client;

    // 1. Ambil data mutabaah beserta relasi data siswa
    final response = await supabase
        .from('mutabaah_records')
        .select('siswa_id, achieved_amount, created_at, siswa!inner(nama_lengkap, lembaga_id)')
        .eq('siswa.lembaga_id', organizationId);

    final List<dynamic> records = response as List<dynamic>;

    // 2. Kalkulasi Leaderboard Santri (Top 10)
    final Map<String, Map<String, dynamic>> studentTotals = {};
    for (var rec in records) {
      final siswaId = rec['siswa_id'] as String?;
      if (siswaId == null) continue;
      final siswaData = rec['siswa'] as Map<String, dynamic>?;
      final namaLengkap = siswaData?['nama_lengkap'] as String? ?? 'Santri';
      final amount = (rec['achieved_amount'] as num?)?.toDouble() ?? 0.0;

      if (!studentTotals.containsKey(siswaId)) {
        studentTotals[siswaId] = {
          'id': siswaId,
          'name': namaLengkap,
          'total': 0.0,
        };
      }
      studentTotals[siswaId]!['total'] =
          (studentTotals[siswaId]!['total'] as double) + amount;
    }

    final List<TopStudent> topStudents = studentTotals.values.map((e) {
      return TopStudent(
        id: e['id'] as String,
        name: e['name'] as String,
        totalAchieved: e['total'] as double,
      );
    }).toList();

    topStudents.sort((a, b) => b.totalAchieved.compareTo(a.totalAchieved));
    final top10 = topStudents.take(10).toList();

    // 3. Proses Heatmap Data (DayIndex: 1=Sen, 2=Sel, 3=Rab, 4=Kam | Hours: 5..21)
    final Map<int, Map<int, int>> heatmap = {
      1: {},
      2: {},
      3: {},
      4: {},
    };

    for (var rec in records) {
      final createdAtStr = rec['created_at'] as String?;
      if (createdAtStr == null) continue;
      final dt = DateTime.parse(createdAtStr).toLocal();
      final dayIndex = dt.weekday; // 1 = Monday, 4 = Thursday
      if (dayIndex >= 1 && dayIndex <= 4) {
        final hour = dt.hour;
        if (hour >= 5 && hour <= 21) {
          heatmap[dayIndex]![hour] = (heatmap[dayIndex]![hour] ?? 0) + 1;
        }
      }
    }

    return AnalyticsState(
      topStudents: top10,
      heatmapData: heatmap,
    );
  }
}