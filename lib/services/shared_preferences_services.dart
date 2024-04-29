import 'dart:convert';

import 'package:daily_wrapped/models/spotify_api_credentials_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';

class SharedPreferencesService {
  static final SharedPreferencesService _instance =
      SharedPreferencesService._internal();

  factory SharedPreferencesService() {
    return _instance;
  }

  SharedPreferencesService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveStringValue(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getStringValue(String key) {
    return _prefs.getString(key);
  }

  Future<void> saveCredentials(SpotifyApiCredentials creds) async {
    await _prefs.setString('credentials', jsonEncode(creds.toJson()));
  }

  SpotifyApiCredentials? getCredentials() {
    final credsJson = _prefs.getString('credentials');
    if (credsJson != null) {
      return SpotifyApiCredentialsExtensions.fromJson(jsonDecode(credsJson));
    }

    return null;
  }
}
