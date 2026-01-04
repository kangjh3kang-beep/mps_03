import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/bluetooth/bluetooth_service.dart';

abstract class BluetoothEvent extends Equatable {
  const BluetoothEvent();
  @override
  List<Object?> get props => [];
}

class BluetoothScanRequested extends BluetoothEvent {
  const BluetoothScanRequested();
}

class BluetoothDeviceConnected extends BluetoothEvent {
  final String deviceId;
  const BluetoothDeviceConnected({required this.deviceId});
  @override
  List<Object> get props => [deviceId];
}

abstract class BluetoothState extends Equatable {
  const BluetoothState();
  @override
  List<Object?> get props => [];
}

class BluetoothInitial extends BluetoothState {
  const BluetoothInitial();
}

class BluetoothScanning extends BluetoothState {
  const BluetoothScanning();
}

class BluetoothDevicesFound extends BluetoothState {
  final List<dynamic> devices;
  const BluetoothDevicesFound({required this.devices});
  @override
  List<Object> get props => [devices];
}

class BluetoothConnected extends BluetoothState {
  final String deviceId;
  const BluetoothConnected({required this.deviceId});
  @override
  List<Object> get props => [deviceId];
}

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  final BluetoothService bluetoothService;
  
  BluetoothBloc(this.bluetoothService) : super(const BluetoothInitial()) {
    on<BluetoothScanRequested>(_onScanRequested);
    on<BluetoothDeviceConnected>(_onDeviceConnected);
  }
  
  Future<void> _onScanRequested(BluetoothScanRequested event, Emitter<BluetoothState> emit) async {
    emit(const BluetoothScanning());
    // TODO: Implement
  }
  
  Future<void> _onDeviceConnected(BluetoothDeviceConnected event, Emitter<BluetoothState> emit) async {
    // TODO: Implement
  }
}
