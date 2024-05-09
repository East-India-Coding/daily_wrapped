import 'dart:math' as math;

import 'package:daily_wrapped/providers/spotify_auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:spotify/spotify.dart' hide Image;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class RecentlyPlayedPage extends StatefulWidget {
  const RecentlyPlayedPage({super.key});

  @override
  State<RecentlyPlayedPage> createState() => _RecentlyPlayedPageState();
}

class _RecentlyPlayedPageState extends State<RecentlyPlayedPage> {
  String? geminiOutput;
  Set<String?> albumSet = {};

  @override
  Widget build(BuildContext context) {
    final pH = context.watch<SpotifyAuthNotifier>().playHistory;

    if (pH.isNotEmpty && geminiOutput == null) {
      getPersonalityFromGemini(pH);
      for (final t in pH) {
        albumSet.add(t.album?.images?[0].url);
      }
    }

    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.black87,
    //   ),
    // );

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        children: [
          Transform.rotate(
            angle: -math.pi / 9,
            child: Transform.scale(
              scale: 1.75,
              child: GridView.custom(
                gridDelegate: SliverQuiltedGridDelegate(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  repeatPattern: QuiltedGridRepeatPattern.inverted,
                  pattern: [
                    QuiltedGridTile(2, 2),
                    QuiltedGridTile(1, 1),
                    QuiltedGridTile(1, 1),
                    QuiltedGridTile(1, 2),
                  ],
                ),
                physics: const NeverScrollableScrollPhysics(),
                childrenDelegate: SliverChildBuilderDelegate(
                  (context, index) => tile(albumSet.toList(), index),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.30),
                  Colors.black.withOpacity(0.95)
                ],
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    "$geminiOutput",
                    style: TextStyle(
                        fontSize: 30.sp,
                        color: Colors.white70,
                        fontFamily: 'Daily',
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    context.read<SpotifyAuthNotifier>().recentlyPlayed();
    super.initState();
  }

  getPersonalityFromGemini(List<Track> pH) async {
    List<String?> songsList = [];
    for (var track in pH) {
      songsList.add(track.name);
    }

    try {
      final gemini = Gemini.instance;
      final output = await gemini.text(
          "Give the personality of a user in 10 words who recently listened to these songs: $songsList");
      geminiOutput = output?.output.toString();
    } catch (e) {
      print(e);
      geminiOutput = "Some error occurred. Try again later!";
    }
    setState(() {});
  }

  tile(List<String?> images, int index) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(
              image: NetworkImage(
                "${index >= images.length ? images[0] : images[index]}",
              ),
              fit: BoxFit.cover)),
      // child: Image.network(
      //   "${index >= images.length ? images[0] : images[index]}",
      //   fit: BoxFit.cover,
      // ),
    );
  }
}
