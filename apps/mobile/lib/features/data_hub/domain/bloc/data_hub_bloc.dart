import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ============================================================================
// STATES
// ============================================================================

abstract class DataHubState extends Equatable {
  const DataHubState();

  @override
  List<Object> get props => [];
}

class DataHubInitial extends DataHubState {
  const DataHubInitial();
}

class DataHubLoading extends DataHubState {
  const DataHubLoading();
}

class TrendDataLoaded extends DataHubState {
  final List<TrendPoint> trendPoints;
  final String metricType; // glucose, cholesterol, etc.
  final String period; // day, week, month, year
  final TrendStats stats;

  const TrendDataLoaded({
    required this.trendPoints,
    required this.metricType,
    required this.period,
    required this.stats,
  });

  @override
  List<Object> get props => [trendPoints, metricType, period, stats];
}

class CorrelationDataLoaded extends DataHubState {
  final List<CorrelationItem> correlations;
  final String variable1; // glucose, etc.
  final String variable2; // exercise, etc.

  const CorrelationDataLoaded({
    required this.correlations,
    required this.variable1,
    required this.variable2,
  });

  @override
  List<Object> get props => [correlations, variable1, variable2];
}

class ReportGenerated extends DataHubState {
  final String reportPath;
  final DateTime startDate;
  final DateTime endDate;
  final String reportType; // pdf, excel, etc.

  const ReportGenerated({
    required this.reportPath,
    required this.startDate,
    required this.endDate,
    required this.reportType,
  });

  @override
  List<Object> get props => [reportPath, startDate, endDate, reportType];
}

class SyncStatusUpdated extends DataHubState {
  final Map<String, bool> syncStatus;
  final int syncedRecords;

  const SyncStatusUpdated({
    required this.syncStatus,
    required this.syncedRecords,
  });

  @override
  List<Object> get props => [syncStatus, syncedRecords];
}

class FamilyDataLoaded extends DataHubState {
  final List<FamilyMember> members;
  final int totalMembers;

  const FamilyDataLoaded({
    required this.members,
    required this.totalMembers,
  });

  @override
  List<Object> get props => [members, totalMembers];
}

class DataHubError extends DataHubState {
  final String message;
  final Exception? exception;

  const DataHubError({
    required this.message,
    this.exception,
  });

  @override
  List<Object> get props => [message];
}

// ============================================================================
// EVENTS
// ============================================================================

abstract class DataHubEvent extends Equatable {
  const DataHubEvent();

  @override
  List<Object> get props => [];
}

class LoadTrendData extends DataHubEvent {
  final String metricType;
  final String period;

  const LoadTrendData({
    required this.metricType,
    required this.period,
  });

  @override
  List<Object> get props => [metricType, period];
}

class LoadCorrelationData extends DataHubEvent {
  final String variable1;
  final String variable2;

  const LoadCorrelationData({
    required this.variable1,
    required this.variable2,
  });

  @override
  List<Object> get props => [variable1, variable2];
}

class GenerateReport extends DataHubEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String reportType;

  const GenerateReport({
    required this.startDate,
    required this.endDate,
    required this.reportType,
  });

  @override
  List<Object> get props => [startDate, endDate, reportType];
}

class SyncWithExternalService extends DataHubEvent {
  final String serviceName;
  final bool enable;

  const SyncWithExternalService({
    required this.serviceName,
    required this.enable,
  });

  @override
  List<Object> get props => [serviceName, enable];
}

class LoadFamilyData extends DataHubEvent {
  const LoadFamilyData();
}

class AddFamilyMember extends DataHubEvent {
  final String name;
  final String relationship;
  final String email;

  const AddFamilyMember({
    required this.name,
    required this.relationship,
    required this.email,
  });

  @override
  List<Object> get props => [name, relationship, email];
}

class RemoveFamilyMember extends DataHubEvent {
  final String memberId;

  const RemoveFamilyMember({required this.memberId});

  @override
  List<Object> get props => [memberId];
}

class UpdateFamilyMemberPermission extends DataHubEvent {
  final String memberId;
  final String permission;
  final bool granted;

  const UpdateFamilyMemberPermission({
    required this.memberId,
    required this.permission,
    required this.granted,
  });

  @override
  List<Object> get props => [memberId, permission, granted];
}

// ============================================================================
// BLOC
// ============================================================================

class DataHubBloc extends Bloc<DataHubEvent, DataHubState> {
  DataHubBloc() : super(const DataHubInitial()) {
    on<LoadTrendData>(_onLoadTrendData);
    on<LoadCorrelationData>(_onLoadCorrelationData);
    on<GenerateReport>(_onGenerateReport);
    on<SyncWithExternalService>(_onSyncWithExternalService);
    on<LoadFamilyData>(_onLoadFamilyData);
    on<AddFamilyMember>(_onAddFamilyMember);
    on<RemoveFamilyMember>(_onRemoveFamilyMember);
    on<UpdateFamilyMemberPermission>(_onUpdateFamilyMemberPermission);
  }

  // Track family members
  final List<FamilyMember> _familyMembers = [];
  final Map<String, bool> _syncStatus = {
    'Apple Health': false,
    'Google Fit': false,
    'Samsung': false,
    'Oura': false,
    'Fitbit': false,
    'Garmin': false,
  };

  Future<void> _onLoadTrendData(
    LoadTrendData event,
    Emitter<DataHubState> emit,
  ) async {
    try {
      emit(const DataHubLoading());
      
      // Mock data generation
      await Future.delayed(const Duration(seconds: 1));

      final trendPoints = _generateMockTrendPoints(event.metricType, event.period);
      final stats = _calculateStats(trendPoints);

      emit(TrendDataLoaded(
        trendPoints: trendPoints,
        metricType: event.metricType,
        period: event.period,
        stats: stats,
      ));
    } catch (e) {
      emit(DataHubError(
        message: 'Failed to load trend data: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onLoadCorrelationData(
    LoadCorrelationData event,
    Emitter<DataHubState> emit,
  ) async {
    try {
      emit(const DataHubLoading());
      
      await Future.delayed(const Duration(seconds: 1));

      final correlations = _generateMockCorrelations(
        event.variable1,
        event.variable2,
      );

      emit(CorrelationDataLoaded(
        correlations: correlations,
        variable1: event.variable1,
        variable2: event.variable2,
      ));
    } catch (e) {
      emit(DataHubError(
        message: 'Failed to load correlation data: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onGenerateReport(
    GenerateReport event,
    Emitter<DataHubState> emit,
  ) async {
    try {
      emit(const DataHubLoading());
      
      await Future.delayed(const Duration(seconds: 2));

      emit(ReportGenerated(
        reportPath: '/documents/health_report_${DateTime.now().timestamp()}.pdf',
        startDate: event.startDate,
        endDate: event.endDate,
        reportType: event.reportType,
      ));
    } catch (e) {
      emit(DataHubError(
        message: 'Failed to generate report: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onSyncWithExternalService(
    SyncWithExternalService event,
    Emitter<DataHubState> emit,
  ) async {
    try {
      emit(const DataHubLoading());
      
      // Update sync status
      _syncStatus[event.serviceName] = event.enable;
      
      await Future.delayed(const Duration(seconds: 1));

      emit(SyncStatusUpdated(
        syncStatus: Map.from(_syncStatus),
        syncedRecords: _calculateSyncedRecords(),
      ));
    } catch (e) {
      emit(DataHubError(
        message: 'Failed to sync with external service: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onLoadFamilyData(
    LoadFamilyData event,
    Emitter<DataHubState> emit,
  ) async {
    try {
      emit(const DataHubLoading());
      
      await Future.delayed(const Duration(seconds: 1));

      emit(FamilyDataLoaded(
        members: List.from(_familyMembers),
        totalMembers: _familyMembers.length,
      ));
    } catch (e) {
      emit(DataHubError(
        message: 'Failed to load family data: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onAddFamilyMember(
    AddFamilyMember event,
    Emitter<DataHubState> emit,
  ) async {
    try {
      _familyMembers.add(FamilyMember(
        id: 'member_${_familyMembers.length + 1}',
        name: event.name,
        relationship: event.relationship,
        email: event.email,
        permissions: {'view': true, 'export': false, 'share': false},
      ));

      emit(FamilyDataLoaded(
        members: List.from(_familyMembers),
        totalMembers: _familyMembers.length,
      ));
    } catch (e) {
      emit(DataHubError(
        message: 'Failed to add family member: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onRemoveFamilyMember(
    RemoveFamilyMember event,
    Emitter<DataHubState> emit,
  ) async {
    try {
      _familyMembers.removeWhere((member) => member.id == event.memberId);

      emit(FamilyDataLoaded(
        members: List.from(_familyMembers),
        totalMembers: _familyMembers.length,
      ));
    } catch (e) {
      emit(DataHubError(
        message: 'Failed to remove family member: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onUpdateFamilyMemberPermission(
    UpdateFamilyMemberPermission event,
    Emitter<DataHubState> emit,
  ) async {
    try {
      final memberIndex = _familyMembers.indexWhere((m) => m.id == event.memberId);
      if (memberIndex >= 0) {
        final member = _familyMembers[memberIndex];
        member.permissions[event.permission] = event.granted;
      }

      emit(FamilyDataLoaded(
        members: List.from(_familyMembers),
        totalMembers: _familyMembers.length,
      ));
    } catch (e) {
      emit(DataHubError(
        message: 'Failed to update permissions: $e',
        exception: e as Exception?,
      ));
    }
  }

  // ============================================================================
  // MOCK DATA GENERATION
  // ============================================================================

  List<TrendPoint> _generateMockTrendPoints(String metricType, String period) {
    final points = <TrendPoint>[];
    final now = DateTime.now();
    int dataPoints = period == 'day' ? 24 : period == 'week' ? 7 : period == 'month' ? 30 : 365;

    for (int i = 0; i < dataPoints; i++) {
      final date = now.subtract(Duration(days: dataPoints - i - 1));
      final baseValue = metricType == 'glucose' ? 120 : metricType == 'cholesterol' ? 200 : 140;
      final variance = (-50 + (i * 100) % 100).toDouble();

      points.add(TrendPoint(
        date: date,
        value: baseValue + variance,
        label: _formatDateForPeriod(date, period),
      ));
    }

    return points;
  }

  List<CorrelationItem> _generateMockCorrelations(String var1, String var2) {
    final correlations = <CorrelationItem>[];
    
    correlations.add(CorrelationItem(
      variable1: var1,
      variable2: var2,
      correlation: 0.78,
      interpretation: '$var1이(가) 높을수록 $var2이(가)높아지는 경향',
      dataPoints: 45,
    ));

    correlations.add(CorrelationItem(
      variable1: var1,
      variable2: 'exercise',
      correlation: -0.65,
      interpretation: '운동이 많을수록 $var1이(가)낮아지는 경향',
      dataPoints: 45,
    ));

    correlations.add(CorrelationItem(
      variable1: var1,
      variable2: 'stress',
      correlation: 0.45,
      interpretation: '스트레스가 높을수록 $var1이(가)높아지는 경향',
      dataPoints: 40,
    ));

    return correlations;
  }

  TrendStats _calculateStats(List<TrendPoint> points) {
    if (points.isEmpty) {
      return TrendStats(average: 0, max: 0, min: 0, trend: 'stable');
    }

    final values = points.map((p) => p.value).toList();
    final average = values.reduce((a, b) => a + b) / values.length;
    final max = values.reduce((a, b) => a > b ? a : b);
    final min = values.reduce((a, b) => a < b ? a : b);

    final firstHalf = values.sublist(0, (values.length / 2).round());
    final secondHalf = values.sublist((values.length / 2).round());
    final avgFirst = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
    final avgSecond = secondHalf.reduce((a, b) => a + b) / secondHalf.length;

    final trend = avgSecond > avgFirst ? 'up' : avgSecond < avgFirst ? 'down' : 'stable';

    return TrendStats(
      average: average,
      max: max,
      min: min,
      trend: trend,
    );
  }

  String _formatDateForPeriod(DateTime date, String period) {
    if (period == 'day') return '${date.hour}:00';
    if (period == 'week') return '${date.month}/${date.day}';
    if (period == 'month') return '${date.month}/${date.day}';
    return '${date.month}월';
  }

  int _calculateSyncedRecords() {
    final enabledServices = _syncStatus.values.where((v) => v).length;
    return enabledServices * 150;
  }
}

// ============================================================================
// MODELS
// ============================================================================

class TrendPoint extends Equatable {
  final DateTime date;
  final double value;
  final String label;

  const TrendPoint({
    required this.date,
    required this.value,
    required this.label,
  });

  @override
  List<Object> get props => [date, value, label];
}

class TrendStats extends Equatable {
  final double average;
  final double max;
  final double min;
  final String trend; // up, down, stable

  const TrendStats({
    required this.average,
    required this.max,
    required this.min,
    required this.trend,
  });

  @override
  List<Object> get props => [average, max, min, trend];
}

class CorrelationItem extends Equatable {
  final String variable1;
  final String variable2;
  final double correlation; // -1 to 1
  final String interpretation;
  final int dataPoints;

  const CorrelationItem({
    required this.variable1,
    required this.variable2,
    required this.correlation,
    required this.interpretation,
    required this.dataPoints,
  });

  @override
  List<Object> get props => [variable1, variable2, correlation, interpretation, dataPoints];
}

class FamilyMember extends Equatable {
  final String id;
  final String name;
  final String relationship;
  final String email;
  final Map<String, bool> permissions;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.relationship,
    required this.email,
    required this.permissions,
  });

  @override
  List<Object> get props => [id, name, relationship, email, permissions];
}

extension on DateTime {
  int get timestamp => millisecondsSinceEpoch;
}
