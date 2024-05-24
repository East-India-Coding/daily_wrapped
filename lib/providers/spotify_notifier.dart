import 'dart:async';

import 'package:daily_wrapped/services/shared_preferences_services.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SpotifyNotifier extends ChangeNotifier {
  SpotifyApi? spotify;
  Future<String> Function(String authUri)? getCodeFromWebView;
  final SharedPreferencesService _prefs = SharedPreferencesService();
  User? user;
  List<Track> playHistory = [];
  List<Artist> topArtists = [];
  List<Track> topSongs = [];

  final _scopes = [
    AuthorizationScope.user.readPrivate,
    AuthorizationScope.user.readEmail,
    AuthorizationScope.playlist.readPrivate,
    AuthorizationScope.playlist.readCollaborative,
    AuthorizationScope.connect.readPlaybackState,
    AuthorizationScope.connect.readCurrentlyPlaying,
    AuthorizationScope.library.read,
    AuthorizationScope.listen.readPlaybackPosition,
    AuthorizationScope.listen.readRecentlyPlayed,
    AuthorizationScope.listen.readTop,
    AuthorizationScope.follow.read,
    AuthorizationScope.follow.modify,
  ];

  userLogin() async {
    await dotenv.load(fileName: ".env");
    final clientId = dotenv.env['clientId'];
    final clientSecret = dotenv.env['secret'];

    final creds = _prefs.getCredentials();
    if (creds != null) {
      spotify = SpotifyApi(
        SpotifyApiCredentials(
          clientId,
          clientSecret,
          accessToken: creds.accessToken,
          refreshToken: creds.refreshToken,
          expiration: creds.expiration,
          scopes: creds.scopes,
        ),
        onCredentialsRefreshed: (SpotifyApiCredentials newCreds) async {
          _prefs.saveCredentials(newCreds);
        },
      );
      if (spotify != null) return;
    }

    var credentials = SpotifyApiCredentials(clientId, clientSecret);
    spotify = await _getUserAuthenticatedSpotifyApi(credentials);

    if (spotify != null) {
      var creds = await spotify!.getCredentials();
      _prefs.saveCredentials(creds);
    }
  }

  Future<SpotifyApi> _getUserAuthenticatedSpotifyApi(
      SpotifyApiCredentials credentials) async {
    var redirect = "https://toseefkhan403.github.io/";

    var grant = SpotifyApi.authorizationCodeGrant(credentials);
    var authUri =
        grant.getAuthorizationUrl(Uri.parse(redirect), scopes: _scopes);

    final code = await getCodeFromWebView?.call(authUri.toString());

    var client = await grant.handleAuthorizationResponse({"code": "$code"});
    return SpotifyApi.fromClient(client);
  }

  Future<void> getUserDetails() async {
    user = await spotify?.me.get();
    notifyListeners();
  }

  Future<List<Track>> recentlyPlayed() async {
    playHistory.clear();
    var stream = spotify?.me.recentlyPlayed().stream();

    if(stream != null) {
      await for (final page in stream) {
        for(var pH in page.items!) {
          playHistory.add(pH.track!);
          // print(pH.track?.album?.images?[0].url);
        }
      }
    }
    notifyListeners();

    return playHistory;
  }

  Future<List<Artist>> getTopArtists() async {
    topArtists.clear();
    var stream = spotify?.me.topArtists().stream();

    if(stream != null) {
      await for (final page in stream) {
        for(var artist in page.items!) {
          topArtists.add(artist);
        }
      }
    }
    notifyListeners();

    return topArtists;
  }

  Future<List<Track>> getTopSongs() async {
    topSongs.clear();
    var stream = spotify?.me.topTracks().stream();

    if(stream != null) {
      await for (final page in stream) {
        for(var song in page.items!) {
          topSongs.add(song);
        }
      }
    }
    notifyListeners();

    return topSongs;
  }
}
