import 'package:daily_wrapped/providers/gemini_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class GeminiDescriptionBottomSheet extends StatelessWidget {
  const GeminiDescriptionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final desc = context.read<GeminiNotifier>().geminiOutput?.description;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 18.w),
      child: Column(
        children: [
          Container(
            width: 150.w,
            height: 3.5.h,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
            ),
            margin: EdgeInsets.only(top: 8.h, bottom: 12.h),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                "$desc",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
