import 'package:daily_wrapped/views/sharable_story_page.dart';
import 'package:daily_wrapped/views/utils/app_colors.dart';
import 'package:daily_wrapped/views/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/gemini_notifier.dart';
import '../providers/spotify_notifier.dart';

class CardDeckPage extends StatefulWidget {
  const CardDeckPage({super.key});

  @override
  State<CardDeckPage> createState() => _CardDeckPageState();
}

class _CardDeckPageState extends State<CardDeckPage> {
  List<int> _cardIndexes = List.generate(4, (i) => i);
  int _selectedIndex = 0;
  late CustomCarouselScrollController _controller;

  @override
  void initState() {
    _init();
    _controller = CustomCarouselScrollController();
    super.initState();
  }

  _init() async {
    final spotifyProvider = context.read<SpotifyNotifier>();
    spotifyProvider.recentlyPlayed().then((pH) => context
        .read<GeminiNotifier>()
        .getRecentlyPlayedPersonality(pH)
        .then((_) => _shuffleDeck.call()));
  }

  @override
  Widget build(BuildContext context) {
    final geminiOutput = context.watch<GeminiNotifier>().recentlyPlayedOutput;

    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: SafeArea(
          child: geminiOutput.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 16.h, left: 6.w, right: 6.w),
                      child: Text(
                        "Recently Played",
                        style: TextStyle(
                            fontSize: 30.sp,
                            color: Colors.white,
                            fontFamily: 'Daily',
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(child: _buildCarousel(geminiOutput)),
                    Padding(
                      padding: EdgeInsets.only(bottom: 32.h, top: 16.h),
                      child: _buildNextBtn(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildCarousel(List<String?> geminiOutput) {
    List<Widget> items = List.generate(
        _cardIndexes.length, (i) => _Card(_cardIndexes[i], geminiOutput));

    return CustomCarousel(
      // Enable `sticky` physics so you can only "throw" one card at a time:
      physics: const CustomCarouselScrollPhysics(sticky: true),
      // Creates the stack of 3 cards behind the selected card:
      itemCountBefore: 3,
      // We don't want any cards left on screen after they "scroll off":
      itemCountAfter: 0,
      // Start all the cards in the middle (we'll move them around from there):
      alignment: Alignment.center,
      // The user will use horizontal scroll interactions:
      scrollDirection: Axis.horizontal,
      // Slow down scroll interactions a bit:
      scrollSpeed: 0.5,
      // We don't want to let the user tap to scroll to (ie. select) a card:
      tapToSelect: false,
      // We'll use our own controller so that we can navigate the cards via
      // the "Next Card" / "Shuffle Deck" button:
      controller: _controller,
      // Create the effectsBuilder using Animate, so we can leverage pre-built
      // effects like shimmer, tint, and shadows:
      effectsBuilder: CustomCarousel.effectsBuilderFromAnimate(
        // This is quite a complex effects list, but we'll try to break it
        // down into understandable chunks.
        //
        // The specific duration doesn't really matter, but to make it
        // easier to think about, we'll use 200ms. The "middle" at 100ms
        // is when the card is selected. So 0-100ms is "before"
        // the card is selected, and 100-200ms is "after".
        //
        // Effects are applied in the order they are added to the list, so
        // we'll start with the effects that happen "on the card", versus
        // "to the card".
        effects: EffectList()
            // This tint will run from 0-100, so untint as it approaches the
            // front of the stack (ie. approaches the middle). It's what makes
            // the cards in the background a little darker.
            .untint(
              duration: 100.ms,
              color: Colors.black45,
            )
            // Inherits the 100ms duration, and the delay makes this run from
            // 100-200, so it animates as the card leaves the stack
            // (ie. leaves the middle). It creates the gloss effect across
            // the face of the card as it flips.
            .shimmer(
              delay: 100.ms,
              color: Colors.white70,
              angle: 3.1,
            )
            // This inherits the 100-200 timing from the shimmer. It animates
            // the shadow behind the card as it flips.
            .boxShadow(
              begin: const BoxShadow(
                color: Colors.black38,
                blurRadius: 0,
                spreadRadius: -4,
                offset: Offset(0, 0),
              ),
              end: BoxShadow(
                color: Colors.black.withOpacity(0),
                blurRadius: 24,
                offset: const Offset(-48, 0),
              ),
              borderRadius: BorderRadius.circular(24),
            )
            // the following effects happen "to the card" (ex. moving it around)
            // so we'll add them at the end of the list.
            //
            // This rotation resets the delay to 0, thereby running from 0-100.
            // It subtley rotates the cards in the stack as they move to the front.
            .rotate(
              delay: 0.ms,
              curve: Curves.easeIn,
              begin: 0.02,
            )
            // The 2.5d card flip as it leaves the stack (100-200).
            .flipH(
              delay: 100.ms,
              end: -0.15,
              alignment: Alignment.center,
              perspective: 2,
            )
            // Slides the card to the right as it leaves the stack (100-200).
            .slideX(end: 1.5),
      ),
      // This is mostly just used to update the "Next Card" button to say
      // "Shuffle Deck" when the last card is selected.
      onSelectedItemChanged: (i) => setState(() => _selectedIndex = i),
      children: items,
    );
  }

  Widget _buildNextBtn() {
    return GestureDetector(
      onTap: () {
        if (_selectedIndex == 0) {
          _shuffleDeck();
        } else {
          _controller.previousItem(duration: 1000.ms);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Text(
          _selectedIndex == 0 ? 'Reset' : 'Next Card',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  _shuffleDeck() {
    setState(() {
      _cardIndexes = _cardIndexes.sublist(1);
      _cardIndexes.shuffle();
      _cardIndexes.insert(0, 0);
      _controller.animateToItem(_cardIndexes.length - 1, duration: 800.ms);
    });
  }
}

class _Card extends StatelessWidget {
  const _Card(this.index, this.geminiOutput, {super.key});

  // index for bg cover - geminiOutput for text
  final int index;
  final List<String?> geminiOutput;

  @override
  Widget build(BuildContext context) {
    Widget card = GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => Scaffold(
                  backgroundColor: Colors.black87,
                  body: SharableStoryPage(geminiOutput[index])))),
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: Colors.white,
              width: 15.w,
            ),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r), child: cardWidget()),
        ),
      ),
    );

    return card;
  }

  Widget? cardWidget() {
    print(index);
    if (index == 0) {
      return ClipRect(child: SharableStoryPage(geminiOutput[index]));
    }

    if (index == 1) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/squares.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: textOverlay(geminiOutput[index]),
      );
    }

    if (index == 2) {
      return ClipRect(
          child: SharableStoryPage(
        geminiOutput[index],
        isRotated: false,
      ));
    }

    if (index == 3) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/moon.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: textOverlay(geminiOutput[index]),
      );
    }

    return Container(
      color: Colors.black,
    );
  }
}
