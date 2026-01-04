import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../domain/entities/measurement.dart';

class BluetoothService {
  final FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;
  final _connectionStateController = StreamController<bool>.broadcast();
  final _waveformController = StreamController<List<double>>.broadcast();
  
  Stream<bool> get connectionState => _connectionStateController.stream;
  Stream<List<double>> get waveformData => _waveformController.stream;
  
  Future<List<ReaderDevice>> scanForDevices() async {
    final devices = <ReaderDevice>[];
    
    try {
      await _flutterBlue.startScan(timeout: const Duration(seconds: 10));
      
      await for (final result in _flutterBlue.scanResults) {
        for (final r in result) {
          if (r.advertisementData.localName.startsWith('MPS-')) {
            devices.add(ReaderDevice(
              id: r.device.remoteId.str,
              name: r.advertisementData.localName,
              deviceType: 'reader',
              rssi: r.rssi,
            ));
          }
        }
      }
    } catch (e) {
      throw Exception('Failed to scan devices: $e');
    } finally {
      await _flutterBlue.stopScan();
    }
    
    return devices;
  }
  
  Future<bool> connectToDevice(ReaderDevice device) async {
    try {
      // TODO: Implement BLE connection
      _connectionStateController.add(true);
      return true;
    } catch (e) {
      _connectionStateController.add(false);
      return false;
    }
  }
  
  Future<void> disconnect() async {
    _connectionStateController.add(false);
  }
  
  void dispose() {
    _connectionStateController.close();
    _waveformController.close();
  }
}
