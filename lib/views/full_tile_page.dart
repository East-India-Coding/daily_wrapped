import 'package:daily_wrapped/providers/gemini_notifier.dart';
import 'package:daily_wrapped/views/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FullTilePage extends StatelessWidget {
  final String? img;

  const FullTilePage(this.img, {super.key});

  @override
  Widget build(BuildContext context) {
    final geminiOutput = context.watch<GeminiNotifier>().geminiOutput;

    return Scaffold(
      backgroundColor: Colors.black87,
      body: geminiOutput == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 300.h,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: NetworkImage(img ?? ""),
                      fit: BoxFit.cover,
                    )),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.90),
                              Colors.black.withOpacity(0.10),
                            ],
                          ),
                        ),
                        child: Text(
                          geminiOutput.title,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 2.h,
                    ),
                    child: Text(
                      geminiOutput.description,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
