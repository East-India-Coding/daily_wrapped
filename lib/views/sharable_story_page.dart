import 'dart:math' as math;

import 'package:daily_wrapped/providers/spotify_notifier.dart';
import 'package:daily_wrapped/views/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/enums.dart';

class SharableStoryPage extends StatefulWidget {
  const SharableStoryPage(this.bgType, this.cardType, this.geminiOutput,
      {super.key});

  final BackgroundType bgType;
  final MenuCardType cardType;
  final String? geminiOutput;

  @override
  State<SharableStoryPage> createState() => _SharableStoryPageState();
}

class _SharableStoryPageState extends State<SharableStoryPage> {
  Set<String?> imagesSet = {};

  @override
  void initState() {
    fillImagesSet();
    super.initState();
  }

  fillImagesSet() {
    final provider = context.read<SpotifyNotifier>();

    switch (widget.cardType) {
      case MenuCardType.recentlyPlayed:
        final pH = provider.playHistory;
        if (pH.isNotEmpty) {
          for (final t in pH) {
            imagesSet.add(t.album?.images?[0].url);
          }
        }
        break;
      case MenuCardType.topArtists:
        final pH = provider.topArtists;
        if (pH.isNotEmpty) {
          for (final artist in pH) {
            imagesSet.add(artist.images?[0].url);
          }
        }
        break;
      case MenuCardType.topSongs:
        final pH = provider.topSongs;
        if (pH.isNotEmpty) {
          for (final t in pH) {
            imagesSet.add(t.album?.images?[0].url);
          }
        }
        break;
      case MenuCardType.musicPersonality:
      // TODO: Handle this case.
      case MenuCardType.musicMood:
      // TODO: Handle this case.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        getBackground(widget.bgType),
        textOverlay(widget.geminiOutput),
        // shareButtons
        // Row(
        //   children: [
        //     Container(
        //       decoration: BoxDecoration(
        //         shape: ,
        //       ),
        //       child: IconButton(
        //         icon: Icon(
        //
        //         ), onPressed: () {  },
        //       ),
        //     )
        //   ],
        // )
      ],
    );
  }

  gridView() => GridView.custom(
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          repeatPattern: QuiltedGridRepeatPattern.inverted,
          pattern: [
            const QuiltedGridTile(2, 2),
            const QuiltedGridTile(1, 1),
            const QuiltedGridTile(1, 1),
            const QuiltedGridTile(1, 2),
          ],
        ),
        physics: const NeverScrollableScrollPhysics(),
        childrenDelegate: SliverChildBuilderDelegate(
          (context, index) => tile(imagesSet.toList(), index),
        ),
      );

  tile(List<String?> images, int index) {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20.r),
        ),
        image: DecorationImage(
            image: NetworkImage(
              "${index >= images.length ? images[0] : images[index]}",
            ),
            fit: BoxFit.cover),
      ),
    );
  }

  Widget getBackground(BackgroundType bgType) {
    switch (bgType) {
      case BackgroundType.image:
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/squares.jpg"),
                fit: BoxFit.cover),
          ),
        );
      case BackgroundType.albumCovers:
        return gridView();
      case BackgroundType.albumCoversRotated:
        return Transform.rotate(
          angle: -math.pi / 9,
          child: Transform.scale(
            scale: 1.75,
            child: gridView(),
          ),
        );
    }
  }
}
