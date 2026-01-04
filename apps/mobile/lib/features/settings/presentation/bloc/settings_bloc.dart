import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class UpdateSettings extends SettingsEvent {
  final Map<String, dynamic> settings;
  const UpdateSettings({required this.settings});
  @override
  List<Object> get props => [settings];
}

abstract class SettingsState extends Equatable {
  const SettingsState();
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoaded extends SettingsState {
  final Map<String, dynamic> settings;
  const SettingsLoaded({required this.settings});
  @override
  List<Object> get props => [settings];
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final dynamic repository;
  
  SettingsBloc(this.repository) : super(const SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateSettings>(_onUpdateSettings);
  }
  
  Future<void> _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    // TODO: Implement
  }
  
  Future<void> _onUpdateSettings(UpdateSettings event, Emitter<SettingsState> emit) async {
    // TODO: Implement
  }
}
