import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/keuangan_provider.dart';

class FinanceReportScreen extends ConsumerWidget {
  const FinanceReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(financeReportProvider);
    final selectedYear = ref.watch(selectedFinanceYearProvider);

    const List<String> monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Keuangan Eksekutif'),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export PDF',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menyiapkan berkas Laporan Keuangan (PDF)...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.table_chart),
            tooltip: 'Export Excel',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menyiapkan data Laporan Keuangan (Excel)...')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Tahun
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Periode Laporan Tahunan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<int>(
                  value: selectedYear,
                  items: [2024, 2025, 2026, 2027].map((y) {
                    return DropdownMenuItem<int>(
                      value: y,
                      child: Text('Tahun $y', style: const TextStyle(fontWeight: FontWeight.bold)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      ref.read(selectedFinanceYearProvider.notifier).setYear(val);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            reportAsync.when(
              data: (data) {
                final List<double> incomeSeries = List<double>.from(data['income'] ?? List.filled(12, 0.0));
                final List<double> expenseSeries = List<double>.from(data['expense'] ?? List.filled(12, 0.0));

                final double totalIncome = incomeSeries.fold(0.0, (sum, val) => sum + val);
                final double totalExpense = expenseSeries.fold(0.0, (sum, val) => sum + val);
                final double netProfit = totalIncome - totalExpense;

                // Mencari nilai maksimum untuk scaling grafik
                double maxVal = 1000000;
                for (int i = 0; i < 12; i++) {
                  if (incomeSeries[i] > maxVal) maxVal = incomeSeries[i];
                  if (expenseSeries[i] > maxVal) maxVal = expenseSeries[i];
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cards Ringkasan Eksekutif
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            title: 'Pemasukan',
                            amount: totalIncome,
                            color: const Color(0xFF10B981),
                            icon: Icons.arrow_downward_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryCard(
                            title: 'Pengeluaran',
                            amount: totalExpense,
                            color: Colors.red,
                            icon: Icons.arrow_upward_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryCard(
                      title: 'Surplus / Defisit Bersih',
                      amount: netProfit,
                      color: netProfit >= 0 ? Colors.blue : Colors.orange,
                      icon: Icons.account_balance_wallet,
                      isFullWidth: true,
                    ),
                    const SizedBox(height: 28),

                    // Visual Chart Pendapatan vs Pengeluaran
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Grafik Tren Pemasukan vs Pengeluaran',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            _buildLegendItem('Pemasukan', const Color(0xFF10B981)),
                            const SizedBox(width: 12),
                            _buildLegendItem('Pengeluaran', Colors.red),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Container(
                      height: 220,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(12, (index) {
                          final incRatio = (incomeSeries[index] / maxVal).clamp(0.05, 1.0);
                          final expRatio = (expenseSeries[index] / maxVal).clamp(0.05, 1.0);

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // Bar Pemasukan
                                    Container(
                                      width: 8,
                                      height: 140 * incRatio,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    // Bar Pengeluaran
                                    Container(
                                      width: 8,
                                      height: 140 * expRatio,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                monthNames[index],
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 18,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  'Rp ${amount.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: isFullWidth ? 18 : 15, fontWeight: FontWeight.w900, color: color),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }
}