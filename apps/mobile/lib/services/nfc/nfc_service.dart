import 'package:nfc_manager/nfc_manager.dart';
import '../../domain/entities/measurement.dart';

class NFCService {
  bool _isAvailable = false;
  
  Future<void> initialize() async {
    _isAvailable = await NfcManager.instance.isAvailable();
  }
  
  bool get isAvailable => _isAvailable;
  
  Future<CartridgeInfo?> readCartridgeTag() async {
    if (!_isAvailable) return null;
    
    CartridgeInfo? cartridgeInfo;
    
    try {
      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          final ndef = Ndef.from(tag);
          if (ndef != null) {
            final message = await ndef.read();
            if (message != null) {
              cartridgeInfo = _parseCartridgeData(message.records);
            }
          }
          await NfcManager.instance.stopSession();
        },
      );
    } catch (e) {
      await NfcManager.instance.stopSession(errorMessage: e.toString());
    }
    
    return cartridgeInfo;
  }
  
  CartridgeInfo _parseCartridgeData(List<NdefRecord> records) {
    // TODO: Parse NFC data
    return CartridgeInfo(
      id: 'temp',
      type: 'glucose',
      lotNumber: 'LOT001',
      manufactureDate: DateTime.now(),
      expiryDate: DateTime.now().add(const Duration(days: 365)),
      calibrationData: {},
      maxUses: 1,
      currentUses: 0,
    );
  }
}
