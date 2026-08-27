import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/audit_log_model.dart';
import '../providers/audit_log_provider.dart';

class AuditLogScreen extends ConsumerWidget {
  final String organizationId;

  const AuditLogScreen({super.key, required this.organizationId});

  Color _getActionColor(String action) {
    switch (action.toUpperCase()) {
      case 'INSERT':
        return Colors.green;
      case 'UPDATE':
        return Colors.orange;
      case 'DELETE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showDetailModal(BuildContext context, AuditLogModel log) {
    const encoder = JsonEncoder.withIndent('  ');
    final oldJsonStr = log.oldData != null
        ? encoder.convert(log.oldData)
        : 'Tidak Ada Data';
    final newJsonStr = log.newData != null
        ? encoder.convert(log.newData)
        : 'Tidak Ada Data';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detail Audit Mutasi - ${log.tableName} (${log.action})'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.red.shade50,
                        width: double.infinity,
                        child: const Text(
                          'DATA LAMA (OLD DATA)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            child: SelectableText(
                              oldJsonStr,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.green.shade50,
                        width: double.infinity,
                        child: const Text(
                          'DATA BARU (NEW DATA)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            child: SelectableText(
                              newJsonStr,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(auditLogProvider(organizationId));
    final notifier = ref.read(auditLogProvider(organizationId).notifier);

    final tables = ['Semua', 'siswa', 'invoices', 'mutabaah_records'];
    final actions = ['Semua', 'INSERT', 'UPDATE', 'DELETE'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Log System'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(auditLogProvider(organizationId)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            asyncState.when(
              data: (state) => Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_list, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: state.selectedTable ?? 'Semua',
                          decoration: const InputDecoration(
                            labelText: 'Tabel Target',
                            border: InputBorder.none,
                          ),
                          items: tables.map((t) {
                            return DropdownMenuItem(value: t, child: Text(t));
                          }).toList(),
                          onChanged: (val) => notifier.filterByTable(val),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: state.selectedAction ?? 'Semua',
                          decoration: const InputDecoration(
                            labelText: 'Aksi Mutasi',
                            border: InputBorder.none,
                          ),
                          items: actions.map((a) {
                            return DropdownMenuItem(value: a, child: Text(a));
                          }).toList(),
                          onChanged: (val) => notifier.filterByAction(val),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: asyncState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Terjadi error: $err')),
                data: (state) {
                  if (state.logs.isEmpty) {
                    return const Center(child: Text('Tidak ada log mutasi ditemukan.'));
                  }
                  return ListView.builder(
                    itemCount: state.logs.length,
                    itemBuilder: (context, index) {
                      final log = state.logs[index];
                      final actionColor = _getActionColor(log.action);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: actionColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              log.action,
                              style: TextStyle(
                                color: actionColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          title: Text(
                            'Tabel: ${log.tableName}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Oleh: ${log.actorName ?? 'Sistem/Unknown'} | ${log.createdAt.toLocal()}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.compare_arrows),
                            tooltip: 'Bandingkan Data',
                            onPressed: () => _showDetailModal(context, log),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}