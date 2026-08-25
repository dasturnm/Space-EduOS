import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/invoice_model.dart';
import '../providers/keuangan_provider.dart';
import '../services/keuangan_service.dart';
import '../widgets/payment_modal.dart';

class SppListScreen extends ConsumerWidget {
  const SppListScreen({super.key});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'issued':
        return Colors.blue;
      case 'partial':
        return Colors.orange;
      case 'paid':
        return const Color(0xFF10B981);
      case 'overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _triggerBatchGenerateInvoices(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Generate Tagihan SPP Massal'),
        content: const Text(
          'Sistem akan menerbitkan invoice SPP bulan berjalan secara otomatis untuk seluruh santri aktif yang belum memiliki tagihan.\n\nLanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Proses Generate', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
    }

    try {
      final service = KeuanganService();
      final newInvoices = await service.generateInvoices(ref);

      if (context.mounted) {
        Navigator.pop(context); // Tutup loading dialog
        ref.invalidate(invoiceListProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newInvoices.isEmpty
                  ? 'Seluruh santri aktif sudah memiliki tagihan bulan ini.'
                  : 'Berhasil menerbitkan ${newInvoices.length} tagihan SPP baru.',
            ),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal generate tagihan: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _openPaymentModal(BuildContext context, WidgetRef ref, InvoiceModel invoice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => PaymentModal(
        invoice: invoice,
        onPaymentSuccess: () {
          ref.invalidate(invoiceListProvider);
          ref.invalidate(financeReportProvider);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(sppStatusFilterProvider);
    final invoiceListAsync = ref.watch(invoiceListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Tagihan SPP'),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter Status Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildFilterChip(ref, label: 'Semua', value: '', selectedValue: selectedFilter),
                _buildFilterChip(ref, label: 'Belum Bayar', value: 'issued', selectedValue: selectedFilter),
                _buildFilterChip(ref, label: 'Dicicil', value: 'partial', selectedValue: selectedFilter),
                _buildFilterChip(ref, label: 'Lunas', value: 'paid', selectedValue: selectedFilter),
              ],
            ),
          ),
          const Divider(height: 1),

          // List Tagihan Invoice
          Expanded(
            child: invoiceListAsync.when(
              data: (invoices) {
                if (invoices.isEmpty) {
                  return const Center(
                    child: Text('Belum ada data tagihan SPP.'),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: invoices.length,
                  itemBuilder: (context, index) {
                    final item = invoices[index];
                    final statusColor = _getStatusColor(item.status);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.invoiceNumber,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: statusColor),
                                  ),
                                  child: Text(
                                    item.status.toUpperCase(),
                                    style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Tgl Jatuh Tempo: ${item.dueDate.day}/${item.dueDate.month}/${item.dueDate.year}',
                                style: const TextStyle(color: Colors.grey, fontSize: 13)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Sisa Tagihan:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    Text(
                                      'Rp ${item.outstanding.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: item.outstanding > 0 ? Colors.red : const Color(0xFF10B981),
                                      ),
                                    ),
                                  ],
                                ),
                                if (item.status != 'paid')
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF10B981),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () => _openPaymentModal(context, ref, item),
                                    icon: const Icon(Icons.payment, color: Colors.white, size: 18),
                                    label: const Text('Bayar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _triggerBatchGenerateInvoices(context, ref),
        backgroundColor: const Color(0xFF10B981),
        icon: const Icon(Icons.autorenew, color: Colors.white),
        label: const Text('Generate Tagihan SPP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFilterChip(
      WidgetRef ref, {
        required String label,
        required String value,
        required String selectedValue,
      }) {
    final isSelected = value == selectedValue;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: const Color(0xFF10B981).withValues(alpha: 0.2),
        checkmarkColor: const Color(0xFF10B981),
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF10B981) : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (_) {
          ref.read(sppStatusFilterProvider.notifier).setStatus(value);
        },
      ),
    );
  }
}