import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsLocalDatasource {
  final SharedPreferences prefs;
  final FlutterSecureStorage secureStorage;
  
  SettingsLocalDatasource(this.prefs, this.secureStorage);
  
  // TODO: Implement
}
