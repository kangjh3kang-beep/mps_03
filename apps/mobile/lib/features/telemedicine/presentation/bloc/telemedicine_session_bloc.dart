import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class TelemedicineSessionEvent extends Equatable {
  const TelemedicineSessionEvent();
  @override
  List<Object?> get props => [];
}

class LoadSession extends TelemedicineSessionEvent {
  final String sessionId;
  const LoadSession(this.sessionId);
  @override
  List<Object> get props => [sessionId];
}

class SessionJoined extends TelemedicineSessionEvent {
  const SessionJoined();
}

class RemoteUserJoined extends TelemedicineSessionEvent {
  final int remoteUid;
  const RemoteUserJoined(this.remoteUid);
  @override
  List<Object> get props => [remoteUid];
}

class RemoteUserLeft extends TelemedicineSessionEvent {
  final int remoteUid;
  const RemoteUserLeft(this.remoteUid);
  @override
  List<Object> get props => [remoteUid];
}

class EndSession extends TelemedicineSessionEvent {
  const EndSession();
}

abstract class TelemedicineSessionState extends Equatable {
  const TelemedicineSessionState();
  @override
  List<Object?> get props => [];
}

class SessionLoading extends TelemedicineSessionState {
  const SessionLoading();
}

class SessionActive extends TelemedicineSessionState {
  final String sessionId;
  final int? remoteUid;
  final dynamic doctor;
  final List<dynamic> patientMeasurements;
  final String? aiCoachingSummary;
  final String? dietSummary;
  
  const SessionActive({
    required this.sessionId,
    this.remoteUid,
    this.doctor,
    required this.patientMeasurements,
    this.aiCoachingSummary,
    this.dietSummary,
  });
  
  Stream<Duration> get elapsedTimeStream {
    return Stream.periodic(const Duration(seconds: 1), (i) => Duration(seconds: i));
  }
  
  @override
  List<Object?> get props => [
    sessionId,
    remoteUid,
    doctor,
    patientMeasurements,
    aiCoachingSummary,
    dietSummary,
  ];
}

class SessionError extends TelemedicineSessionState {
  final String message;
  const SessionError({required this.message});
  @override
  List<Object> get props => [message];
}

class TelemedicineSessionBloc extends Bloc<TelemedicineSessionEvent, TelemedicineSessionState> {
  final dynamic getDoctorsUsecase;
  final dynamic bookAppointmentUsecase;
  final dynamic videoService;
  
  TelemedicineSessionBloc(
    this.getDoctorsUsecase,
    this.bookAppointmentUsecase,
    this.videoService,
  ) : super(const SessionLoading()) {
    on<LoadSession>(_onLoadSession);
    on<SessionJoined>(_onSessionJoined);
    on<RemoteUserJoined>(_onRemoteUserJoined);
    on<RemoteUserLeft>(_onRemoteUserLeft);
    on<EndSession>(_onEndSession);
  }
  
  Future<void> _onLoadSession(LoadSession event, Emitter<TelemedicineSessionState> emit) async {
    // TODO: Implement
  }
  
  Future<void> _onSessionJoined(SessionJoined event, Emitter<TelemedicineSessionState> emit) async {
    // TODO: Implement
  }
  
  Future<void> _onRemoteUserJoined(RemoteUserJoined event, Emitter<TelemedicineSessionState> emit) async {
    // TODO: Implement
  }
  
  Future<void> _onRemoteUserLeft(RemoteUserLeft event, Emitter<TelemedicineSessionState> emit) async {
    // TODO: Implement
  }
  
  Future<void> _onEndSession(EndSession event, Emitter<TelemedicineSessionState> emit) async {
    // TODO: Implement
  }
}
