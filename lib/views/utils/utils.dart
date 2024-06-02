import 'package:daily_wrapped/views/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slider_button/slider_button.dart';

import '../gemini_description_bottom_sheet.dart';

Widget textOverlay(context, String? text) => Container(
      height: MediaQuery.of(context).size.height * 0.30,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: const [0, 0.85, 1],
          colors: [
            Colors.black.withOpacity(0.95),
            Colors.black.withOpacity(0.65),
            Colors.black.withOpacity(0.10),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Text(
              "$text",
              style: TextStyle(
                  fontSize: 25.sp,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 2.h, 8.w, 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.midnightPurple,
                    borderRadius: BorderRadius.all(
                      Radius.circular(230.r),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(30.r),
                            right: Radius.circular(30.r),
                          ),
                        ),
                        backgroundColor: Colors.black.withOpacity(0.8),
                        builder: (c) => const GeminiDescriptionBottomSheet(),
                      );
                    },
                    padding: EdgeInsets.all(
                      17.w,
                    ),
                    icon: Icon(
                      CupertinoIcons.info,
                      color: Colors.white70,
                      size: 28.w,
                    ),
                  ),
                ),
                sliderButton(),
              ],
            ),
          ),
        ],
      ),
    );

sliderButton() {
  return SliderButton(
    action: () async {
      print("working");
      return false;
    },
    label: Text(
      "Slide to share",
      style: TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
      ),
      textAlign: TextAlign.center,
    ),
    icon: Center(
        child: Icon(
      Icons.share,
      color: Colors.white70,
      size: 28.w,
    )),
    boxShadow: BoxShadow(
      color: Colors.black,
      blurRadius: 2.r,
    ),
    shimmer: true,
    vibrationFlag: true,
    width: 230.w,
    radius: 30.r,
    buttonColor: AppColors.midnightPurple,
    backgroundColor: AppColors.midnightPurple.withOpacity(0.6),
    highlightedColor: Colors.white,
    baseColor: AppColors.skyWhite,
  );
}
