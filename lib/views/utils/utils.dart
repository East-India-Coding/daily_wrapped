import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget textOverlay(String? text) => Container(
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
        Padding(
          padding: EdgeInsets.all(8.w),
          child: Text(
            "$text",
            style: TextStyle(
                fontSize: 26.sp,
                color: Colors.white70,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  ),
);