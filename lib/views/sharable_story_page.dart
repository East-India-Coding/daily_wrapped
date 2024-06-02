import 'dart:async';
import 'dart:math' as math;
import 'dart:math';

import 'package:daily_wrapped/providers/interaction_notifier.dart';
import 'package:daily_wrapped/providers/spotify_notifier.dart';
import 'package:daily_wrapped/views/utils/app_colors.dart';
import 'package:daily_wrapped/views/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../models/enums.dart';
import '../providers/gemini_notifier.dart';
import 'full_tile_page.dart';

class SharableStoryPage extends StatefulWidget {
  const SharableStoryPage(this.cardType, {super.key});

  final MenuCardType cardType;

  @override
  State<SharableStoryPage> createState() => _SharableStoryPageState();
}

class _SharableStoryPageState extends State<SharableStoryPage> {
  Set<String?> imagesSet = {};
  late TransformationController _transformationController;

  @override
  void initState() {
    _init();
    _transformationController = TransformationController();

    // Create a 2D rotation matrix
    Matrix4 rotationMatrix = Matrix4.identity()..rotateZ(-math.pi / 9);
    Matrix4 scalingMatrix = Matrix4.identity()..scale(3.5);

    // Combine the rotation and scaling matrices
    _transformationController.value = rotationMatrix * scalingMatrix;
    super.initState();
  }

  void _onInteractionUpdate(ScaleUpdateDetails details) {
    context.read<InteractionNotifier>().setIsInteracting(true);
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    Future.delayed(const Duration(milliseconds: 600), () {
      context.read<InteractionNotifier>().setIsInteracting(false);
    });
  }

  _init() async {
    final spotifyProvider = context.read<SpotifyNotifier>();
    final geminiProvider = context.read<GeminiNotifier>();
    switch (widget.cardType) {
      case MenuCardType.topArtists:
        final top = await spotifyProvider.getTopArtists();
        if (top.isNotEmpty) {
          for (final artist in top) {
            imagesSet.add(artist.images?[0].url);
          }
        }
        geminiProvider.getTopArtistsPersonality(top);
        break;

      case MenuCardType.topSongs:
        final top = await spotifyProvider.getTopSongs();
        if (top.isNotEmpty) {
          for (final t in top) {
            imagesSet.add(t.album?.images?[0].url);
          }
        }
        geminiProvider.getTopSongsPersonality(top);
        break;

      case MenuCardType.recentlyPlayed:
        final top = await spotifyProvider.recentlyPlayed();
        if (top.isNotEmpty) {
          for (final t in top) {
            imagesSet.add(t.album?.images?[0].url);
          }
        }
        geminiProvider.getRecentlyPlayedPersonality(top);
        break;
      case MenuCardType.musicPersonality:
      // TODO: Handle this case.
      case MenuCardType.musicMood:
      // TODO: Handle this case.

      default:
        final top = await spotifyProvider.getTopArtists();
        if (top.isNotEmpty) {
          for (final artist in top) {
            imagesSet.add(artist.images?[0].url);
          }
        }
        geminiProvider.getTopArtistsPersonality(top);
        break;
    }
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final geminiOutput = context.watch<GeminiNotifier>().geminiOutput;
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      body: geminiOutput == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : PopScope(
              onPopInvoked: (_) {
                context.read<GeminiNotifier>().clearGeminiOutput();
              },
              child: Stack(
                children: [
                  InteractiveViewer(
                    alignment: Alignment.center,
                    boundaryMargin: const EdgeInsets.all(
                      double.infinity,
                    ),
                    minScale: 3.5,
                    onInteractionUpdate: _onInteractionUpdate,
                    onInteractionEnd: _onInteractionEnd,
                    maxScale: 5.5,
                    transformationController: _transformationController,
                    child: gridView(),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Consumer<InteractionNotifier>(
                        builder: (context, ref, child) {
                      return AnimatedOpacity(
                          opacity: ref.isInteracting ? 0 : 1,
                          duration: const Duration(milliseconds: 600),
                          child: textOverlay(context, geminiOutput.title));
                    }),
                  ),
                ],
              ),
            ),
    );
  }

  gridView() => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          childAspectRatio: 1.0,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return tile(imagesSet.toList());
        },
      );

  tile(List<String?> images) {
    final index = Random().nextInt(images.length);
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (c) => FullTilePage(images[index])));
      },
      child: Container(
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(4.r),
          ),
          image: DecorationImage(
              image: NetworkImage(
                "${images[index]}",
              ),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
