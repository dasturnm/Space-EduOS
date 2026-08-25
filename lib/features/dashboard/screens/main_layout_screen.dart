// Lokasi: lib/features/dashboard/screens/main_layout_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/providers/app_context_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/widgets/user_profile_menu.dart';
import 'package:space_eduos/core/navigation/sidebar/app_sidebar.dart';

class MainLayoutScreen extends ConsumerStatefulWidget {
  final Widget child;
  const MainLayoutScreen({super.key, required this.child});

  @override
  ConsumerState<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends ConsumerState<MainLayoutScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(appContextProvider.notifier).initContext();
    });
  }

  @override
  Widget build(BuildContext context) {
    final contextState = ref.watch(appContextProvider);

    if (!contextState.isInitialized && contextState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF10B981)),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 1000;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
        backgroundColor: const Color(0xFF10B981),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Space EduOS", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        actions: const [
          UserProfileMenu(),
          SizedBox(width: 16),
        ],
      )
          : null,
      drawer: isMobile ? const Drawer(child: AppSidebar()) : null,
      body: Row(
        children: [
          if (!isMobile) const AppSidebar(),
          Expanded(
            child: Container(
              color: const Color(0xFFF8FAFC),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}