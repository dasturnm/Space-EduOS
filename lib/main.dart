// Lokasi: lib/main.dart

import 'dart:async'; // TAMBAHAN: Untuk StreamSubscription
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:space_eduos/features/auth/providers/auth_provider.dart' hide AuthState; // FIX: Sembunyikan AuthState lokal agar tidak bentrok dengan Supabase
import 'package:space_eduos/core/providers/app_context_provider.dart';
import 'package:space_eduos/core/routes/app_routes.dart';

// Navigator key diperlukan untuk pindah halaman dari listener auth
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: const String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'https://mrxtnwmyqfmfdncdvssh.supabase.co',
    ),
    anonKey: const String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: 'sb_publishable_OAPUWnbXxiDjKDFMkgvIng_xUKs67lg',
    ),
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  StreamSubscription<AuthState>? _authSubscription; // TAMBAHAN: Menyimpan referensi subscription

  @override
  void initState() {
    super.initState();

    // MENDENGARKAN EVENT AUTH (Termasuk Password Recovery)
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        // Jika link reset diklik, arahkan ke halaman Update Password
        ref.read(routerProvider).push('/update-password');
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel(); // FIX: Batalkan subscription untuk mencegah kebocoran memori (memory leak)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch routerProvider agar mesin GoRouter tersambung ke UI
    final router = ref.watch(routerProvider);

    // --- FIX: Proactive Context Initialization ---
    // Memastikan initContext dijalankan jika user sudah login saat aplikasi dibuka (Cold Start)
    final authState = ref.watch(authProvider);
    final appContext = ref.watch(appContextProvider);

    if (authState.isAuthenticated && appContext.lembaga == null && !appContext.isLoading) {
      Future.microtask(() => ref.read(appContextProvider.notifier).initContext());
    }

    // Listener untuk memicu initContext saat login berhasil (Transisi)
    ref.listen(authProvider, (previous, next) {
      if (next.isAuthenticated && !(previous?.isAuthenticated ?? false)) {
        Future.microtask(() => ref.read(appContextProvider.notifier).initContext());
      }
    });

    return MaterialApp.router(
      routerConfig: router, // Navigator key sekarang dikelola oleh GoRouter
      title: 'Space EduOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF10B981)),
        useMaterial3: true,
      ),
    );
  }
}