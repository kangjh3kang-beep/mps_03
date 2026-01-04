import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class DataHubEvent extends Equatable {
  const DataHubEvent();
  @override
  List<Object?> get props => [];
}

class LoadTrendData extends DataHubEvent {
  final String metricType;
  const LoadTrendData({required this.metricType});
  @override
  List<Object> get props => [metricType];
}

abstract class DataHubState extends Equatable {
  const DataHubState();
  @override
  List<Object?> get props => [];
}

class DataHubInitial extends DataHubState {
  const DataHubInitial();
}

class DataHubLoading extends DataHubState {
  const DataHubLoading();
}

class DataHubLoaded extends DataHubState {
  final List<dynamic> trendData;
  const DataHubLoaded({required this.trendData});
  @override
  List<Object> get props => [trendData];
}

class DataHubBloc extends Bloc<DataHubEvent, DataHubState> {
  final dynamic getTrendDataUsecase;
  
  DataHubBloc(this.getTrendDataUsecase) : super(const DataHubInitial()) {
    on<LoadTrendData>(_onLoadTrendData);
  }
  
  Future<void> _onLoadTrendData(LoadTrendData event, Emitter<DataHubState> emit) async {
    emit(const DataHubLoading());
    // TODO: Implement
  }
}
