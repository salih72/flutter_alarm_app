import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutteralarmapp/feature/extensions/context_extension.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShowAlarmView extends StatefulWidget {
  const ShowAlarmView({super.key});

  @override
  State<ShowAlarmView> createState() => _ShowAlarmViewState();
}

class _ShowAlarmViewState extends State<ShowAlarmView> {
  @override
  void initState() {
    super.initState();
    shakeEventListener();
  }

  void shakeEventListener() {
    accelerometerEventStream()
        .throttleTime(
      const Duration(milliseconds: 500),
    )
        .listen((AccelerometerEvent event) {
      if (event.x > 1.5) {
        stopAlarm();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/image/info.png',
              width: 200.w,
              height: 200.h,
            ),
            Center(
              child: Text(
                "Telefonu Sallayınız",
                style: TextStyle(fontSize: 40.sp),
              ),
            ),
            Card(
              child: MaterialButton(
                onPressed: () async {
                  stopAlarm();
                },
                child: const Text("Alarmı Manuel Kapat"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@pragma('vm:entry-point')
void stopAlarm() async {
  AudioPlayer().stop();
  AndroidAlarmManager.cancel(0);
  exit(0);
}
