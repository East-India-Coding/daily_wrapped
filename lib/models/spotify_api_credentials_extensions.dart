import 'package:spotify/spotify.dart';

extension SpotifyApiCredentialsExtensions on SpotifyApiCredentials {
  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'clientSecret': clientSecret,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiration': expiration?.toIso8601String(),
      'scopes': scopes,
    };
  }

  static SpotifyApiCredentials fromJson(Map<String, dynamic> json) {
    return SpotifyApiCredentials(
      json['clientId'],
      json['clientSecret'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiration: DateTime.parse(json['expiration']),
      scopes: List<String>.from(json['scopes'] ?? []),
    );
  }
}
