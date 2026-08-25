// Lokasi: lib/shared/widgets/app_drawer.dart

import 'package:flutter/material.dart';
import 'package:space_eduos/core/navigation/sidebar/app_sidebar.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: AppSidebar(),
    );
  }
}