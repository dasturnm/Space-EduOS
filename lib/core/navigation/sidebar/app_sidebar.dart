import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../providers/app_context_provider.dart';
import 'sidebar_config.dart';

class AppSidebar extends ConsumerWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextState = ref.watch(appContextProvider);
    final currentRoute = GoRouterState.of(context).uri.toString();

    return Container(
      width: 260,
      color: Colors.white,
      child: Column(
        children: [
          // 1. Header Logo & Branding
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.token_rounded, color: Color(0xFF10B981), size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Space EduOS',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      Text(
                        contextState.lembaga?.namaLembaga ?? 'One Space Ecosystem',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Navigation Menu List (Dual-Gate Filtered)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _SidebarTile(
                  title: 'Beranda',
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard,
                  route: '/dashboard',
                  isSelected: currentRoute == '/dashboard',
                ),

                const SizedBox(height: 12),

                ...SidebarMenuRegistry.sections.map((section) {
                  final validItems = section.items.where((item) {
                    return SidebarMenuRegistry.canAccessItem(
                      item: item,
                      contextState: contextState,
                    );
                  }).toList();

                  if (validItems.isEmpty) return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 16, bottom: 8),
                        child: Text(
                          section.title,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      ...validItems.map((item) {
                        return _SidebarTile(
                          title: item.title,
                          icon: _getIconForRoute(item.route),
                          activeIcon: _getIconForRoute(item.route, active: true),
                          route: item.route,
                          isSelected: currentRoute == item.route,
                        );
                      }),
                    ],
                  );
                }),
              ],
            ),
          ),

          // 3. User Profile & Logout Card
          _buildUserCard(context, ref, contextState),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, WidgetRef ref, AppContextState contextState) {
    final profile = contextState.profile;
    final authUser = Supabase.instance.client.auth.currentUser;

    final String googleName = authUser?.userMetadata?['full_name'] ?? "";
    final String email = authUser?.email ?? "Email tidak tersedia";
    final String avatarUrl = authUser?.userMetadata?['avatar_url'] ?? "";

    final String displayName = (profile?.namaLengkap != null && profile!.namaLengkap.isNotEmpty)
        ? profile.namaLengkap
        : (googleName.isNotEmpty ? googleName : (contextState.isLoading ? "Memuat profil..." : "User"));

    final initial = (displayName != "Memuat profil..." && displayName != "User")
        ? displayName[0].toUpperCase()
        : "?";

    return InkWell(
      onTap: () => context.go('/profile'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFCCFBF1),
              backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
              child: avatarUrl.isEmpty
                  ? Text(initial, style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                  Text(email, style: const TextStyle(color: Colors.grey, fontSize: 11), overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(
                    contextState.isLoading ? "..." : (contextState.role?.toUpperCase() ?? "GUEST"),
                    style: const TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout, size: 18, color: Colors.redAccent),
              onPressed: () => ref.read(authProvider.notifier).logout(),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForRoute(String route, {bool active = false}) {
    switch (route) {
      case '/organisasi':
        return active ? Icons.business : Icons.business_outlined;
      case '/cabang':
        return active ? Icons.account_tree : Icons.account_tree_outlined;
      case '/tahun-ajaran':
        return active ? Icons.calendar_month : Icons.calendar_month_outlined;
      case '/divisi':
        return active ? Icons.domain : Icons.domain_outlined;
      case '/unit-kerja':
        return active ? Icons.work : Icons.work_outline;
      case '/jabatan':
        return active ? Icons.admin_panel_settings : Icons.admin_panel_settings_outlined;
      case '/program':
        return active ? Icons.school : Icons.school_outlined;
      case '/kurikulum':
        return active ? Icons.menu_book : Icons.menu_book_outlined;
      case '/silabus':
        return active ? Icons.auto_stories : Icons.auto_stories_outlined;
      case '/siswa':
        return active ? Icons.people : Icons.people_outline;
      case '/admission':
        return active ? Icons.how_to_reg : Icons.how_to_reg_outlined;
      case '/wali':
        return active ? Icons.family_restroom : Icons.family_restroom_outlined;
      case '/mutabaah':
        return active ? Icons.menu_book_rounded : Icons.menu_book_outlined;
      case '/tasmi':
        return active ? Icons.verified : Icons.verified_outlined;
      case '/mushaf':
        return active ? Icons.import_contacts : Icons.import_contacts_outlined;
      case '/staf':
        return active ? Icons.badge : Icons.badge_outlined;
      case '/presensi':
        return active ? Icons.co_present : Icons.co_present_outlined;
      case '/keuangan':
      case '/keuangan/payroll-settings':
        return active ? Icons.payments : Icons.payments_outlined;
      default:
        return active ? Icons.circle : Icons.circle_outlined;
    }
  }
}

class _SidebarTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final String route;
  final bool isSelected;

  const _SidebarTile({
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.route,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    const Color emerald = Color(0xFF10B981);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? emerald.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? emerald : Colors.grey[600],
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? emerald : const Color(0xFF1E293B),
          ),
        ),
        onTap: () => context.go(route),
      ),
    );
  }
}