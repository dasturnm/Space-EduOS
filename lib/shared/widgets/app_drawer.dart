// Lokasi: lib/shared/widgets/app_drawer.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:space_eduos/core/navigation/sidebar/sidebar_config.dart';
import 'package:space_eduos/core/providers/app_context_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextState = ref.watch(appContextProvider);
    final currentRoute = GoRouterState.of(context).uri.toString();
    final authUser = Supabase.instance.client.auth.currentUser;

    final profile = contextState.profile;
    final String googleName = authUser?.userMetadata?['full_name'] ?? "";
    final String email = authUser?.email ?? "Email tidak tersedia";
    final String avatarUrl = authUser?.userMetadata?['avatar_url'] ?? "";

    final String displayName = (profile?.namaLengkap != null && profile!.namaLengkap.isNotEmpty)
        ? profile.namaLengkap
        : (googleName.isNotEmpty ? googleName : (contextState.isLoading ? "Memuat profil..." : "User"));

    final initial = (displayName != "Memuat profil..." && displayName != "User")
        ? displayName[0].toUpperCase()
        : "?";

    final filteredGroups = SidebarConfig.getGroups().where((group) {
      if (group.module != null && !contextState.hasModule(group.module!)) {
        return false;
      }
      final allowedItems = group.items.where((item) {
        final hasItemModule = item.module == null || contextState.hasModule(item.module!);
        final hasItemPermission = item.permission == null || contextState.hasPermission(item.permission!);
        return hasItemModule && hasItemPermission;
      }).toList();
      return allowedItems.isNotEmpty;
    }).toList();

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF1E293B)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: const Color(0xFFCCFBF1),
              backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
              child: avatarUrl.isEmpty
                  ? Text(initial, style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold))
                  : null,
            ),
            accountName: Text(
              displayName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(email),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: filteredGroups.length,
              itemBuilder: (context, groupIdx) {
                final group = filteredGroups[groupIdx];
                final allowedItems = group.items.where((item) {
                  final hasItemModule = item.module == null || contextState.hasModule(item.module!);
                  final hasItemPermission = item.permission == null || contextState.hasPermission(item.permission!);
                  return hasItemModule && hasItemPermission;
                }).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        group.title.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    ...allowedItems.map((item) {
                      final bool isSelected = currentRoute == item.route;
                      return ListTile(
                        leading: Icon(
                          item.icon,
                          color: isSelected ? const Color(0xFF10B981) : Colors.grey,
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? const Color(0xFF10B981) : const Color(0xFF1E293B),
                          ),
                        ),
                        selected: isSelected,
                        selectedTileColor: const Color(0xFF10B981).withValues(alpha: 0.1),
                        onTap: () {
                          context.pop();
                          context.go(item.route);
                        },
                      );
                    }),
                    const Divider(height: 16),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}