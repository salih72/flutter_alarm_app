import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            "assets/image/info.png",
            width: 390.w,
            height: 390.h,
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
              ),
              children: const [
                TextSpan(text: "\u2023 Mustafa Emir Yerlikaya\n\n"),
                TextSpan(text: "\u2023 Devran Şeker\n\n"),
                TextSpan(text: "\u2023 Muhammed Enes Temel\n\n"),
                TextSpan(text: "\u2023 Salih Samed Cesur\n\n"),
                TextSpan(text: "\u2023 Tahsin Seza Dağdeviren\n\n"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
