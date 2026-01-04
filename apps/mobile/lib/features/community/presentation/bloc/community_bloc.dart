import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class CommunityEvent extends Equatable {
  const CommunityEvent();
  @override
  List<Object?> get props => [];
}

class LoadForums extends CommunityEvent {
  const LoadForums();
}

abstract class CommunityState extends Equatable {
  const CommunityState();
  @override
  List<Object?> get props => [];
}

class CommunityInitial extends CommunityState {
  const CommunityInitial();
}

class CommunityLoading extends CommunityState {
  const CommunityLoading();
}

class CommunityLoaded extends CommunityState {
  final List<dynamic> forums;
  const CommunityLoaded({required this.forums});
  @override
  List<Object> get props => [forums];
}

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final dynamic repository;
  
  CommunityBloc(this.repository) : super(const CommunityInitial()) {
    on<LoadForums>(_onLoadForums);
  }
  
  Future<void> _onLoadForums(LoadForums event, Emitter<CommunityState> emit) async {
    // TODO: Implement
  }
}
