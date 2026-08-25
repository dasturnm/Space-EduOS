import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/expense_model.dart';
import '../providers/keuangan_provider.dart';
import '../services/keuangan_service.dart';

class ExpenseListScreen extends ConsumerWidget {
  const ExpenseListScreen({super.key});

  void _showAddExpenseDialog(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    String category = 'Operasional';
    DateTime selectedDate = DateTime.now();
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(dialogCtx).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tambah Pengeluaran Baru',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(dialogCtx),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: category,
                        decoration: const InputDecoration(
                          labelText: 'Kategori Pengeluaran *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category, color: Color(0xFF10B981)),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Operasional', child: Text('Operasional')),
                          DropdownMenuItem(value: 'Listrik & Air', child: Text('Listrik & Air')),
                          DropdownMenuItem(value: 'Gaji/Honor', child: Text('Gaji / Honor')),
                          DropdownMenuItem(value: 'Pemeliharaan', child: Text('Pemeliharaan Sarpras')),
                          DropdownMenuItem(value: 'Konsumsi', child: Text('Konsumsi')),
                          DropdownMenuItem(value: 'Lainnya', child: Text('Lain-lain')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => category = val);
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Keterangan Pengeluaran *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description, color: Color(0xFF10B981)),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Keterangan wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Nominal (Rp) *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money, color: Color(0xFF10B981)),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Nominal wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: dialogCtx,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Tanggal Pengeluaran *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF10B981)),
                          ),
                          child: Text(
                            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: isLoading
                              ? null
                              : () async {
                            if (!formKey.currentState!.validate()) return;
                            final amount = double.tryParse(amountController.text.trim()) ?? 0;
                            if (amount <= 0) return;

                            setState(() => isLoading = true);

                            try {
                              final supabase = Supabase.instance.client;
                              final user = supabase.auth.currentUser;
                              final profileData = await supabase
                                  .from('profiles')
                                  .select('organization_id, lembaga_id')
                                  .eq('id', user?.id ?? '')
                                  .maybeSingle();

                              final orgId = (profileData?['organization_id'] ?? profileData?['lembaga_id'] ?? '').toString();

                              final expense = ExpenseModel(
                                organizationId: orgId,
                                category: category,
                                description: descriptionController.text.trim(),
                                amount: amount,
                                date: selectedDate,
                              );

                              final service = KeuanganService();
                              await service.addExpense(ref, expense);

                              ref.invalidate(expenseListProvider);
                              ref.invalidate(financeReportProvider);

                              if (context.mounted) {
                                Navigator.pop(dialogCtx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Pengeluaran berhasil dicatat'),
                                    backgroundColor: Color(0xFF10B981),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Gagal menyimpan: $e'), backgroundColor: Colors.red),
                                );
                              }
                            } finally {
                              setState(() => isLoading = false);
                            }
                          },
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Simpan Pengeluaran', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expenseListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengeluaran Operasional'),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
      ),
      body: expensesAsync.when(
        data: (expenses) {
          if (expenses.isEmpty) {
            return const Center(
              child: Text('Belum ada catatan pengeluaran.'),
            );
          }

          final double totalExpense = expenses.fold(0.0, (sum, item) => sum + item.amount);

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.red.shade50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Pengeluaran:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(
                      'Rp ${totalExpense.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.red),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final item = expenses[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red.shade100,
                          child: const Icon(Icons.output_rounded, color: Colors.red),
                        ),
                        title: Text(item.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${item.category} • ${item.date.day}/${item.date.month}/${item.date.year}'),
                        trailing: Text(
                          '- Rp ${item.amount.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 14),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseDialog(context, ref),
        backgroundColor: const Color(0xFF10B981),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Pengeluaran', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}