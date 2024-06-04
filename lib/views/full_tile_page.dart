import 'package:daily_wrapped/providers/gemini_notifier.dart';
import 'package:daily_wrapped/views/utils/utils.dart';
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
                        padding: EdgeInsets.only(top: 8.h),
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
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 2.h,
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
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 6.h,
                    ),
                    child: Text(
                      geminiOutput.description,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  sliderButton(),
                ],
              ),
            ),
    );
  }
}
