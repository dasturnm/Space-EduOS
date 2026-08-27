// Lokasi: lib/features/management_lembaga/screens/struktur_organisasi_hub_screen.dart

import 'package:flutter/material.dart';
import 'divisi_list_screen.dart';
import 'unit_kerja_list_screen.dart';
import 'jabatan_list_screen.dart';

class StrukturOrganisasiHubScreen extends StatelessWidget {
  const StrukturOrganisasiHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Struktur Organisasi"),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Struktur Organisasi",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Kelola divisi, unit kerja, serta jabatan kelembagaan Anda.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                isScrollable: true,
                indicatorColor: Color(0xFF10B981),
                labelColor: Color(0xFF10B981),
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                indicatorWeight: 3,
                tabs: [
                  Tab(child: Row(children: [Icon(Icons.account_tree_outlined, size: 18), SizedBox(width: 8), Text("Divisi")])),
                  Tab(child: Row(children: [Icon(Icons.corporate_fare_outlined, size: 18), SizedBox(width: 8), Text("Unit Kerja")])),
                  Tab(child: Row(children: [Icon(Icons.work_outline, size: 18), SizedBox(width: 8), Text("Jabatan")])),
                ],
              ),
            ),

            const Expanded(
              child: TabBarView(
                children: [
                  DivisiListScreen(),
                  UnitKerjaListScreen(),
                  JabatanListScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}