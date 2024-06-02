import 'dart:convert';

import 'package:daily_wrapped/models/gemini_output.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:spotify/spotify.dart';

class GeminiNotifier extends ChangeNotifier {
  GeminiOutput? geminiOutput;

  clearGeminiOutput() {
    geminiOutput = null;
    notifyListeners();
  }

  Future getRecentlyPlayedPersonality(List<Track> pH) async {
    List<String> songsList = [];
    for (var track in pH) {
      songsList.add(track.name ?? "Back to me");
    }

    final gemini = Gemini.instance;

    try {
      final output = await gemini
          .text(inputFormatting('recently listened songs are', songsList));
      print(output?.output);
      geminiOutput = GeminiOutput.fromJson(outputFormatting(output?.output));
    } catch (e) {
      print(e);
      geminiOutput =
          const GeminiOutput("Some error occurred. Try again later!", "");
    }

    notifyListeners();
  }

  Future getTopArtistsPersonality(List<Artist> val) async {
    List<String> artistsList = [];
    for (var artist in val) {
      String? genre = artist.genres!.isNotEmpty ? artist.genres?.first : "";
      artistsList.add("${artist.name}($genre)");
    }

    final gemini = Gemini.instance;

    try {
      final output =
          await gemini.text(inputFormatting('top artists are', artistsList));
      geminiOutput = GeminiOutput.fromJson(outputFormatting(output?.output));
    } catch (e) {
      print(e);
      geminiOutput =
          const GeminiOutput("Some error occurred. Try again later!", "");
    }

    notifyListeners();
  }

  Future getTopSongsPersonality(List<Track> val) async {
    List<String> songsList = [];
    for (var song in val) {
      songsList.add("${song.name}");
    }

    final gemini = Gemini.instance;

    try {
      final output =
          await gemini.text(inputFormatting('top songs are', songsList));
      print(output?.output);
      geminiOutput = GeminiOutput.fromJson(outputFormatting(output?.output));
    } catch (e) {
      print(e);
      geminiOutput =
          const GeminiOutput("Some error occurred. Try again later!", "");
    }

    notifyListeners();
  }

  String inputFormatting(String str, List<String> list) =>
      """aggressively roast my music taste if my $str: $list. 
               Return the result in stringified JSON using the following structure:
               { "title" : \$title, "description" : \ndescription } 
               Don't include characters that mess up json decode.
               """;

  Map<String, dynamic> outputFormatting(String? output) {
    return jsonDecode(output
            ?.replaceAll("```", "")
            .replaceAll("json", "")
            .replaceAll('\n', '\\n') ??
        "");
  }
}
