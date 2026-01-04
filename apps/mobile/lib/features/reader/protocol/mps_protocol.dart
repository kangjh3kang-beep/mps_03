import 'dart:typed_data';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Manpasik Protocol Standard (MPS) Definitions
class MpsProtocol {
  // Constants
  static const int headerMagic = 0x4D50; // 'MP'
  static const int version = 0x01;

  // Command Set
  static const int cmdGetStatus = 0x01;
  static const int cmdStartMeasure = 0x02;
  static const int cmdStopMeasure = 0x03;
  static const int cmdCalibrate = 0x04;
  static const int cmdDataPacket = 0x10;
  static const int cmdError = 0xFF;

  // Status Codes
  static const int statusIdle = 0x00;
  static const int statusReady = 0x01;
  static const int statusMeasuring = 0x02;
  static const int statusProcessing = 0x03;
  static const int statusError = 0xFF;
}

/// Data Integrity Packet (DIP) Structure
/// Header(2) + Length(2) + Cmd(1) + Seq(4) + Timestamp(8) + Payload(N) + Hash(32)
class DataIntegrityPacket {
  final int command;
  final int sequenceNumber;
  final int timestamp; // Unix timestamp in milliseconds
  final Uint8List payload;
  final String hash;

  DataIntegrityPacket({
    required this.command,
    required this.sequenceNumber,
    required this.timestamp,
    required this.payload,
    required this.hash,
  });

  /// Create a packet from data
  factory DataIntegrityPacket.create(int command, int sequence, Uint8List payload) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final hash = _calculateHash(command, sequence, timestamp, payload);
    
    return DataIntegrityPacket(
      command: command,
      sequenceNumber: sequence,
      timestamp: timestamp,
      payload: payload,
      hash: hash,
    );
  }

  /// Verify packet integrity
  bool verify() {
    final calculatedHash = _calculateHash(command, sequenceNumber, timestamp, payload);
    return hash == calculatedHash;
  }

  /// Calculate SHA-256 hash of the packet content
  static String _calculateHash(int cmd, int seq, int time, Uint8List data) {
    final buffer = BytesBuilder();
    buffer.addByte(cmd);
    buffer.add(_int32ToBytes(seq));
    buffer.add(_int64ToBytes(time));
    buffer.add(data);
    
    final digest = sha256.convert(buffer.toBytes());
    return digest.toString();
  }

  static List<int> _int32ToBytes(int value) {
    return [
      (value >> 24) & 0xFF,
      (value >> 16) & 0xFF,
      (value >> 8) & 0xFF,
      value & 0xFF,
    ];
  }

  static List<int> _int64ToBytes(int value) {
    return [
      (value >> 56) & 0xFF,
      (value >> 48) & 0xFF,
      (value >> 40) & 0xFF,
      (value >> 32) & 0xFF,
      (value >> 24) & 0xFF,
      (value >> 16) & 0xFF,
      (value >> 8) & 0xFF,
      value & 0xFF,
    ];
  }
}
