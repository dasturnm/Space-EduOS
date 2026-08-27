import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/analytics_provider.dart';
import '../widgets/setoran_heatmap_grid.dart';

class AnalyticsDashboardScreen extends ConsumerWidget {
  final String organizationId;

  const AnalyticsDashboardScreen({super.key, required this.organizationId});

  Widget _buildRankBadge(int rank) {
    if (rank == 1) {
      return const CircleAvatar(
        backgroundColor: Colors.amber,
        child: Icon(Icons.workspace_premium, color: Colors.white),
      );
    } else if (rank == 2) {
      return const CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(Icons.workspace_premium, color: Colors.white),
      );
    } else if (rank == 3) {
      return const CircleAvatar(
        backgroundColor: Colors.brown,
        child: Icon(Icons.workspace_premium, color: Colors.white),
      );
    }
    return CircleAvatar(
      backgroundColor: Colors.blue.shade50,
      child: Text(
        '$rank',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(analyticsDashboardProvider(organizationId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics & Dasbor Kinerja"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.invalidate(analyticsDashboardProvider(organizationId)),
          ),
        ],
      ),
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Terjadi kesalahan: $err")),
        data: (state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SetoranHeatmapGrid(heatmapData: state.heatmapData),
                const SizedBox(height: 24),
                const Text(
                  "Leaderboard Santri Terbaik (Top 10)",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (state.topStudents.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("Belum ada data setoran santri."),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.topStudents.length,
                    itemBuilder: (context, index) {
                      final student = state.topStudents[index];
                      final rank = index + 1;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: _buildRankBadge(rank),
                          title: Text(
                            student.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Total Capaian: ${student.totalAchieved.toStringAsFixed(1)} Halaman",
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}