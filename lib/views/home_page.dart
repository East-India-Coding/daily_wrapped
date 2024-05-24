import 'package:daily_wrapped/models/enums.dart';
import 'package:daily_wrapped/models/extensions/enum_extensions.dart';
import 'package:daily_wrapped/views/sharable_story_page.dart';
import 'package:daily_wrapped/views/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'card_deck_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _buildCarousel(),
      ),
    );
  }

  Widget _buildCarousel() {
    List<Widget> items = [];
    for (int i = 0; i < menuItems.length; i++) {
      items.add(MenuCard(
        example: menuItems[i],
        selected: i == _activeIndex,
        key: ValueKey(i),
      ));
    }

    return CustomCarousel(
      alignment: Alignment.center,
      itemCountBefore: 2,
      itemCountAfter: 2,
      scrollSpeed: 1.5,
      loop: true,
      effectsBuilder: CustomCarousel.effectsBuilderFromAnimate(
        effects: EffectList()
            .shimmer(
              delay: 60.ms,
              duration: 140.ms,
              color: Colors.white24,
              angle: 0.3,
            )
            .blurXY(delay: 0.ms, duration: 100.ms, begin: 4)
            .blurXY(delay: 100.ms, end: 4)
            .slideY(delay: 0.ms, duration: 200.ms, begin: -3.25, end: 3.25)
            .flipH(begin: -0.2, end: 0.2),
      ),
      onSettledItemChanged: (i) => setState(() => _activeIndex = i),
      children: items,
    );
  }
}

class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.example,
    this.selected = false,
  });

  final MenuItemData example;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    Widget card = AspectRatio(
      aspectRatio: 0.9,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: example.gradient,
          image: DecorationImage(
            image: AssetImage('assets/images/${example.img}.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(16),
          border: const Border(
            top: BorderSide(color: Colors.white30, width: 2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                example.cardType.convertToTitle(),
                style: const TextStyle(
                  fontSize: 22,
                  fontFamily: 'Franie',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.end,
              ),
            ),
            if (selected)
              Align(
                alignment: Alignment.bottomRight,
                child: _buildTryBtn(),
              )
            else
              const SizedBox(
                height: 33,
              ),
          ],
        ),
      ),
    );

    if (selected) {
      card = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _goto(context, example),
          child: card,
        ),
      );
    }

    return card;
  }

  void _goto(BuildContext context, MenuItemData example) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: example.builder),
    );
  }

  Widget _buildTryBtn() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 7.h),
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
      child: const Text(
        'Generate with AI ✨',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).moveX(begin: -6, curve: Curves.easeOut);
  }
}

class MenuItemData {
  const MenuItemData({
    required this.img,
    required this.cardType,
    required this.gradient,
    required this.builder,
  });

  final String img;
  final MenuCardType cardType;
  final Gradient gradient;
  final WidgetBuilder builder;
}

final List<MenuItemData> menuItems = [
  MenuItemData(
    img: 'weekend-removebg-preview',
    cardType: MenuCardType.recentlyPlayed,
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.maroon,
        Colors.black
      ]
    ),
    builder: (_) => const CardDeckPage(MenuCardType.recentlyPlayed),
  ),
  MenuItemData(
    img: 'taylor',
    cardType: MenuCardType.topArtists,
    gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.skyBlue,
          AppColors.skyWhite,
        ]
    ),
    builder: (_) => const CardDeckPage(MenuCardType.topArtists),
  ),
  MenuItemData(
    img: 'dua',
    cardType: MenuCardType.topSongs,
    gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.purple,
          AppColors.skyWhite,
        ]
    ),
    builder: (_) => const CardDeckPage(MenuCardType.topSongs),
  ),
  MenuItemData(
    img: 'eminem',
    cardType: MenuCardType.musicPersonality,
    gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.skyBlue,
          AppColors.skyWhite,
        ]
    ),
    builder: (_) => const CardDeckPage(MenuCardType.musicPersonality),
  ),
  MenuItemData(
    img: 'harry',
    cardType: MenuCardType.musicMood,
    gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.skyBlue,
          AppColors.skyWhite,
        ]
    ),
    builder: (_) => const CardDeckPage(MenuCardType.musicMood),
  ),
];
