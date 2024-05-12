import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:spotify/spotify.dart';

class GeminiNotifier extends ChangeNotifier {
  List<String?> recentlyPlayedOutput = [];

  Future getRecentlyPlayedPersonality(List<Track> pH) async {
    recentlyPlayedOutput.clear();
    notifyListeners();

    List<String> songsList = [];
    for (var track in pH) {
      songsList.add(track.name ?? "Back to me");
    }

    // divide into 4 equal parts
    List<List<String>> dividedLists = _divideList(songsList, 4);
    final gemini = Gemini.instance;

    for(List<String> input in dividedLists) {
      try {
        final output = await gemini.text(
            "Give the personality of a user in 2 words who recently listened to these songs: $input");
        recentlyPlayedOutput.add(output?.output ?? "");
      } catch (e) {
        print(e);
        recentlyPlayedOutput.add("Some error occurred. Try again later!");
      }
    }
    notifyListeners();
  }

  List<List<String>> _divideList(List<String> originalList, int parts) {
    int length = originalList.length;
    int partLength = (length / parts).ceil(); // Calculate the length of each part

    List<List<String>> dividedLists = [];

    for (int i = 0; i < length; i += partLength) {
      int end = i + partLength;
      if (end > length) end = length; // Ensure the last part doesn't exceed the length of the original list
      dividedLists.add(originalList.sublist(i, end));
    }

    return dividedLists;
  }
}