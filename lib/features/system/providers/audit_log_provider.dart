import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/audit_log_model.dart';

part 'audit_log_provider.g.dart';

class AuditLogState {
  final List<AuditLogModel> logs;
  final bool isLoading;
  final String? selectedTable;
  final String? selectedAction;
  final String? error;

  AuditLogState({
    this.logs = const [],
    this.isLoading = false,
    this.selectedTable,
    this.selectedAction,
    this.error,
  });

  AuditLogState copyWith({
    List<AuditLogModel>? logs,
    bool? isLoading,
    String? selectedTable,
    String? selectedAction,
    String? error,
  }) {
    return AuditLogState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      selectedTable: selectedTable ?? this.selectedTable,
      selectedAction: selectedAction ?? this.selectedAction,
      error: error,
    );
  }
}

@riverpod
class AuditLogNotifier extends _$AuditLogNotifier {
  @override
  FutureOr<AuditLogState> build(String organizationId) async {
    return fetchLogs(organizationId);
  }

  Future<AuditLogState> fetchLogs(
      String orgId, {
        String? tableName,
        String? actionName,
      }) async {
    final supabase = Supabase.instance.client;
    dynamic query = supabase
        .from('audit_logs')
        .select('*, actor:actor_id(nama_lengkap)')
        .eq('organization_id', orgId);

    if (tableName != null && tableName.isNotEmpty && tableName != 'Semua') {
      query = query.eq('table_name', tableName);
    }

    if (actionName != null && actionName.isNotEmpty && actionName != 'Semua') {
      query = query.eq('action', actionName);
    }

    final response =
    await query.order('created_at', ascending: false).limit(100);

    final list = (response as List)
        .map((json) => AuditLogModel.fromJson(json))
        .toList();

    return AuditLogState(
      logs: list,
      isLoading: false,
      selectedTable: tableName,
      selectedAction: actionName,
    );
  }

  Future<void> filterByTable(String? tableName) async {
    final prev = state.value;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchLogs(
      organizationId,
      tableName: tableName,
      actionName: prev?.selectedAction,
    ));
  }

  Future<void> filterByAction(String? action) async {
    final prev = state.value;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchLogs(
      organizationId,
      tableName: prev?.selectedTable,
      actionName: action,
    ));
  }
}