import 'dart:convert';

import 'package:daily_wrapped/models/gemini_output.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify/spotify.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiNotifier extends ChangeNotifier {
  GeminiOutput? geminiOutput;
  GenerativeModel? _model;

  GeminiNotifier() {
    if(_model != null) return;

    final apiKey = dotenv.env['gemini_api_key'];
    if (apiKey != null) {
      _model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: apiKey,
        generationConfig:
            GenerationConfig(responseMimeType: 'application/json'),
      );
    }
  }

  clearGeminiOutput() {
    geminiOutput = null;
    notifyListeners();
  }

  Future getRecentlyPlayedPersonality(List<Track> pH) async {
    List<String> songsList = [];
    for (var track in pH) {
      songsList.add(track.name ?? "Back to me");
    }

    try {
      final output = await _model?.generateContent(
        inputFormatting('recently listened songs are', songsList),
      );
      geminiOutput = GeminiOutput.fromJson(outputFormatting(output?.text));
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

    try {
      final output = await _model
          ?.generateContent(inputFormatting('top artists are', artistsList));
      geminiOutput = GeminiOutput.fromJson(outputFormatting(output?.text));
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

    try {
      final output = await _model
          ?.generateContent(inputFormatting('top songs are', songsList));
      geminiOutput = GeminiOutput.fromJson(outputFormatting(output?.text));
    } catch (e) {
      print(e);
      geminiOutput =
          const GeminiOutput("Some error occurred. Try again later!", "");
    }

    notifyListeners();
  }

  inputFormatting(String str, List<String> list) {
    String prompt = """aggressively roast my music taste if my $str: $list. 
               Return the result in JSON using the following structure:
               { "title" : \$title, "description" : \ndescription }
               title should have 10 words maximum.
               """;
    return [
      Content.text(prompt),
    ];
  }

  Map<String, dynamic> outputFormatting(String? output) {
    return jsonDecode(output ?? "");
  }
}
