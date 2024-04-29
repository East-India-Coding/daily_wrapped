import 'package:daily_wrapped/providers/spotify_auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart' hide Offset;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TrackSimple> playHistory = [];
  int _selectedIndex = 0;
  late CustomCarouselScrollController _controller;

  @override
  void initState() {
    context.read<SpotifyAuthNotifier>().recentlyPlayed();
    _controller = CustomCarouselScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    playHistory = context.watch<SpotifyAuthNotifier>().playHistory;
    final imgUrl = playHistory[_selectedIndex].artists?[0].images?[0].url ?? "https://upload.wikimedia.org/wikipedia/en/7/74/Ye_album_cover.jpg";

    return Scaffold(
      backgroundColor: const Color(0xFF1F1B2E),
      body: SafeArea(
        bottom: false,
        minimum: const EdgeInsets.only(top: 32),
        child: _buildCarousel(),
      ),
    );
  }

  Widget _buildCarousel() {
    List<Widget> items = List.generate(15, (i) => _Card(i));

    // See `card_deck_view.dart` for a fully commented example of using
    // Animate with CustomCarousel.
    return CustomCarousel(
      itemCountBefore: 4,
      itemCountAfter: 4,
      loop: true,
      tapToSelect: true,
      scrollSpeed: 5,
      effectsBuilder: CustomCarousel.effectsBuilderFromAnimate(
        effects: EffectList()
            .tint(begin: 0.5, color: const Color(0xFF1F1B2E))
            .flipV(begin: -0.15, end: 0.5)
            .slideY(end: 0.5)
            .scaleXY(begin: 0.75, curve: Curves.fastEaseInToSlowEaseOut)
            .align(
          begin: const Alignment(0, -1),
          end: const Alignment(0, 1),
          curve: Curves.easeIn,
        ),
      ),
      children: items,
    );
  }
}

class _Card extends StatelessWidget {
  const _Card(this.index, {Key? key}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://qodeinteractive.com/magazine/wp-content/uploads/2020/06/16-Tame-Impala.jpg'),
              fit: BoxFit.cover,
            ),
            border: const Border(
              top: BorderSide(color: Colors.white38, width: 2),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}