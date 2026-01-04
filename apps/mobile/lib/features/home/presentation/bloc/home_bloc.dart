import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ============ 이벤트 ============
abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class HomeDataRequested extends HomeEvent {
  const HomeDataRequested();
}

class HomeDataRefreshed extends HomeEvent {
  const HomeDataRefreshed();
}

// ============ 상태 ============
abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final Map<String, dynamic> healthScore;
  final Map<String, dynamic> environmentStatus;
  final List<dynamic> recentMeasurements;
  final Map<String, dynamic> aiInsight;
  final List<dynamic> connectedReaders;
  final List<dynamic> emergencyContacts;

  const HomeLoaded({
    required this.healthScore,
    required this.environmentStatus,
    required this.recentMeasurements,
    required this.aiInsight,
    required this.connectedReaders,
    required this.emergencyContacts,
  });

  @override
  List<Object?> get props => [
        healthScore,
        environmentStatus,
        recentMeasurements,
        aiInsight,
        connectedReaders,
        emergencyContacts,
      ];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}

// ============ BLoC ============
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeDataRequested>(_onHomeDataRequested);
    on<HomeDataRefreshed>(_onHomeDataRefreshed);
  }

  Future<void> _onHomeDataRequested(
    HomeDataRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(_loadHomeData());
  }

  Future<void> _onHomeDataRefreshed(
    HomeDataRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    emit(_loadHomeData());
  }

  HomeLoaded _loadHomeData() {
    return HomeLoaded(
      healthScore: {
        'score': 85,
        'status': 'Good',
        'daysTrend': 5,
      },
      environmentStatus: {
        'airQuality': 'good',
        'waterQuality': 'safe',
      },
      recentMeasurements: [
        {
          'type': '혈당',
          'result': '108 mg/dL',
          'timestamp': '2시간 전',
        },
        {
          'type': '혈압',
          'result': '128/82 mmHg',
          'timestamp': '어제',
        },
        {
          'type': '심박수',
          'result': '72 bpm',
          'timestamp': '3시간 전',
        },
      ],
      aiInsight: {
        'message': '오늘 혈당이 안정적입니다. 저녁 식사 후 가벼운 산책을 추천드려요.',
      },
      connectedReaders: [
        {
          'deviceName': 'MPS-Reader-001',
          'isConnected': true,
          'batteryLevel': 85,
        },
      ],
      emergencyContacts: [
        {'name': '119', 'type': 'emergency'},
      ],
    );
  }
}
