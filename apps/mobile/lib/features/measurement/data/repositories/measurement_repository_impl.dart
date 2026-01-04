import 'dart:async';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/measurement_repository.dart';
import '../../domain/entities/measurement_entities.dart';
import '../../../services/http_client_service.dart';
import '../../reader/simulation/virtual_reader.dart';
import '../../reader/protocol/mps_protocol.dart';
import '../../../services/socket_service.dart';

class MeasurementRepositoryImpl implements MeasurementRepository {
  final HttpClientService _httpClient;
  final VirtualReader _virtualReader = VirtualReader();
  final SocketService _socketService = SocketService(); // In real app, inject this
  StreamSubscription? _readerSubscription;
  final _waveformController = StreamController<WaveformPoint>.broadcast();

  MeasurementRepositoryImpl(this._httpClient) {
    _socketService.init();
  }

  @override
  Future<Either<Exception, MeasurementSession>> createSession(String userId) async {
    try {
      // For simulation, we also connect the virtual reader
      await _virtualReader.connect();
      
      final response = await _httpClient.post(
        '/measurements/session',
        data: {'user_id': userId, 'timestamp': DateTime.now().toIso8601String()},
      );
      
      final data = response.containsKey('data') ? response['data'] : response;
      return Right(MeasurementSession.fromJson(data));
    } catch (e) {
      return Left(Exception('Failed to create session: $e'));
    }
  }

  @override
  Future<Either<Exception, MeasurementSession>> updateSessionStatus(
      String sessionId, MeasurementPhase status) async {
    try {
      final response = await _httpClient.put(
        '/measurements/session/$sessionId',
        data: {'status': status.name},
      );
      
      _socketService.updateSessionStatus(status.name);

      // Handle Virtual Reader based on status
      if (status == MeasurementPhase.measuring) {
        _startReaderStream();
      } else if (status == MeasurementPhase.analysis || status == MeasurementPhase.completed) {
        _stopReaderStream();
      }

      final data = response.containsKey('data') ? response['data'] : response;
      return Right(MeasurementSession.fromJson(data));
    } catch (e) {
      return Left(Exception('Failed to update session: $e'));
    }
  }

  @override
  Future<Either<Exception, MeasurementSession>> getSession(String sessionId) async {
    try {
      final response = await _httpClient.get('/measurements/session/$sessionId');
      final data = response.containsKey('data') ? response['data'] : response;
      return Right(MeasurementSession.fromJson(data));
    } catch (e) {
      return Left(Exception('Failed to get session: $e'));
    }
  }

  @override
  Stream<WaveformPoint> getMeasurementStream(String sessionId) {
    return _waveformController.stream;
  }

  void _startReaderStream() {
    _virtualReader.startMeasuring();
    _readerSubscription?.cancel();
    _readerSubscription = _virtualReader.dataStream.listen((packet) {
      if (packet.command == MpsProtocol.cmdDataPacket) {
        // Parse float32 payload
        final value = Float32List.view(packet.payload.buffer)[0];
        
        // Send to Backend via Socket
        _socketService.sendMeasurementData({
          'timestamp': packet.timestamp,
          'value': value,
          'sequence': packet.sequenceNumber
        });

        _waveformController.add(WaveformPoint(
          timestamp: DateTime.fromMillisecondsSinceEpoch(packet.timestamp),
          value: value,
        ));
      }
    });
  }

  void _stopReaderStream() {
    _virtualReader.stopMeasuring();
    _readerSubscription?.cancel();
  }
  
  void dispose() {
    _stopReaderStream();
    _virtualReader.disconnect();
    _waveformController.close();
    _socketService.dispose();
  }
}
