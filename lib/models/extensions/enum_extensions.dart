import '../enums.dart';

extension ConvertToTitle on MenuCardType {
  String convertToTitle() {
    switch (this) {
      case MenuCardType.recentlyPlayed:
        return "Recently Played";
      case MenuCardType.topArtists:
        return "Top Artists";
      case MenuCardType.topSongs:
        return "Top Songs";
      case MenuCardType.musicPersonality:
        return "Your music personality";
      case MenuCardType.musicMood:
        return "Your mood based on your recent plays";
    }
  }
}
