import 'dart:math' as math;

import 'package:daily_wrapped/providers/spotify_notifier.dart';
import 'package:daily_wrapped/views/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SharableStoryPage extends StatefulWidget {
  const SharableStoryPage(this.geminiOutput, {this.isRotated = true, super.key});
  final String? geminiOutput;
  final bool isRotated;

  @override
  State<SharableStoryPage> createState() => _SharableStoryPageState();
}

class _SharableStoryPageState extends State<SharableStoryPage> {
  Set<String?> albumSet = {};

  @override
  void initState() {
    final pH = context.read<SpotifyNotifier>().playHistory;

    if (pH.isNotEmpty) {
      for (final t in pH) {
        albumSet.add(t.album?.images?[0].url);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.isRotated ?
        Transform.rotate(
          angle: -math.pi / 9,
          child: Transform.scale(
            scale: 1.75,
            child: gridView(),
          ),
        ) : gridView(),
        textOverlay(widget.geminiOutput),
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
          (context, index) => tile(albumSet.toList(), index),
    ),
  );

  tile(List<String?> images, int index) {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
          image: DecorationImage(
              image: NetworkImage(
                "${index >= images.length ? images[0] : images[index]}",
              ),
              fit: BoxFit.cover)),
    );
  }
}
