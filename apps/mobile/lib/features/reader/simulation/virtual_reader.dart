import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import '../protocol/mps_protocol.dart';

/// Virtual Reader Simulator
/// Simulates the physical behavior of the Manpasik Reader.
class VirtualReader {
  // Simulation Parameters
  static const int sampleRate = 100; // Hz
  static const double baseVoltage = 3.3; // V
  static const double signalAmplitude = 0.5; // V
  static const double noiseLevel = 0.05; // V
  
  // State
  int _status = MpsProtocol.statusIdle;
  Timer? _measureTimer;
  final _controller = StreamController<DataIntegrityPacket>.broadcast();
  int _sequence = 0;
  
  // Physics State
  double _phase = 0.0;
  double _drift = 0.0;
  final Random _random = Random();

  Stream<DataIntegrityPacket> get dataStream => _controller.stream;
  int get status => _status;

  /// Connect to the virtual reader
  Future<void> connect() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate connection delay
    _status = MpsProtocol.statusReady;
  }

  /// Disconnect
  Future<void> disconnect() async {
    stopMeasuring();
    _status = MpsProtocol.statusIdle;
  }

  /// Start measuring process
  void startMeasuring() {
    if (_status != MpsProtocol.statusReady) return;
    
    _status = MpsProtocol.statusMeasuring;
    _sequence = 0;
    _phase = 0.0;
    _drift = 0.0;

    // Simulate 100Hz sampling
    _measureTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      _generateSample();
    });
  }

  /// Stop measuring process
  void stopMeasuring() {
    _measureTimer?.cancel();
    _measureTimer = null;
    if (_status == MpsProtocol.statusMeasuring) {
      _status = MpsProtocol.statusReady;
    }
  }

  /// Generate a single sample point with physics simulation
  void _generateSample() {
    // 1. Base Signal (Sine wave for PPG simulation)
    // Heart rate ~60-100 bpm => 1-1.6 Hz
    double signal = sin(_phase) * signalAmplitude;
    _phase += 0.1; // Increment phase

    // 2. Add Brownian Motion (Random Walk) for drift
    _drift += (_random.nextDouble() - 0.5) * 0.01;
    // Clamp drift
    if (_drift > 0.2) _drift = 0.2;
    if (_drift < -0.2) _drift = -0.2;

    // 3. Add White Noise
    double noise = (_random.nextDouble() - 0.5) * noiseLevel;

    // 4. Combine
    double value = baseVoltage + signal + _drift + noise;

    // 5. Create Payload (Float32)
    final payload = Float32List.fromList([value]);
    final bytes = payload.buffer.asUint8List();

    // 6. Create DIP
    final packet = DataIntegrityPacket.create(
      MpsProtocol.cmdDataPacket,
      _sequence++,
      bytes,
    );

    _controller.add(packet);
  }
}
