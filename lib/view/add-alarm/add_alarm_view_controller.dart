// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';
import 'package:flutteralarmapp/feature/extensions/context_extension.dart';
import 'package:flutteralarmapp/feature/init/cache/local_storage.dart';
import 'package:flutteralarmapp/feature/models/alarm_model.dart';
import 'package:flutteralarmapp/feature/services/database/alarm_database_provider.dart';
import 'package:flutteralarmapp/feature/services/notification/notification_service.dart';
import 'package:flutteralarmapp/view/app/app_controller.dart';
import 'package:flutteralarmapp/view/app/app_main.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAlarmViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddAlarmViewController());
  }
}

class AddAlarmViewController extends GetxController {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String alarmTitle = '';
  int notificationMinutes = 5;
  final AudioPlayer audioPlayer = AudioPlayer();
  RxString selectedRingtone = ''.obs;
  RxString selectedRingtonePath = ''.obs;

  final AlarmDatabaseProvider database = AlarmDatabaseProvider.instance;

  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      selectedDate = pickedDate;
      update(); // Widget'ı güncellemek için
    }
  }

  Future<void> selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      selectedTime = pickedTime;
      update(); // Widget'ı güncellemek için
    }
  }

  void onAlarmTitleChanged(String value) {
    alarmTitle = value;
  }

  void onNotificationMinutesChanged(int? value) {
    if (value != null) {
      notificationMinutes = value;
    }
  }

  Future<void> pickRingtone(BuildContext context) async {
    var ringtones = await FlutterSystemRingtones.getRingtoneSounds();

    Get.bottomSheet(
      SizedBox(
        height: 500.h,
        child: ListView(
          padding: context.paddingLow,
          shrinkWrap: true,
          children: [
            Container(
              width: 375.w,
              height: 50.h,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(15),
              ),
              child: MaterialButton(
                child: const Text('Kaydet'),
                onPressed: () async {
                  await stopRingtone();
                  Get.back();
                },
              ),
            ),
            const Divider(),
            ...ringtones.map((Ringtone ringtone) {
              return ListTile(
                title: Text(ringtone.title),
                onTap: () async {
                  await playRingtone(ringtone.uri);
                  selectedRingtone.value = ringtone.title;
                  selectedRingtonePath.value = ringtone.uri;
                },
              );
            }).toList(),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<void> playRingtone(String uri) async {
    await audioPlayer.setAudioSource(
      AudioSource.uri(Uri.parse(uri)),
    );
    await audioPlayer.play();
  }

  Future<void> stopRingtone() async {
    await audioPlayer.stop();
  }

  Future<void> saveRingtone() async {
    try {
      var entity = AlarmModel(
        title: alarmTitle,
        ringtoneTitle: selectedRingtone.value,
        ringtonePath: selectedRingtonePath.value,
        dateTime: combineDateAndTime(selectedDate!, selectedTime!),
      );

      await LocalStorage.setFilePath(selectedRingtonePath.value);
      await database.add(entity);

      //5 Dakika öncesinde bildirim göndermesi metodu test için yorum satırında
      /* await NotificationService.showNotification(
      title: alarmTitle,
      body: "Alarmınzın çalmasına $notificationMinutes dakika kaldı.",
      scheduled: true,
      interval: entity.dateTime!.difference(DateTime.now()).inSeconds -
          60 * notificationMinutes,
    ); */

      //alarmın çaldığı metot test için 10 saniyeye ayarlandı
      await AndroidAlarmManager.oneShot(
        const Duration(
          seconds: /* entity.dateTime!.difference(DateTime.now()).inSeconds */
          10,
        ),
        12345,
        callbackFunc,
      );

      //alarmın çaldığı metot test için 10 saniyeye ayarlandı (asenkron kısımlar yaklaşık 10 saniye gecikme olduğu için 20 saniye yazıldı)
      await NotificationService.showNotification(
        title: alarmTitle,
        body: "Alarmınzınız Çalışıyor.",
        scheduled: true,
        interval: /* entity.dateTime!.difference(DateTime.now()).inSeconds */
        20,
        payload: {
          "navigate": "true",
        },
        actionButtons: [
          NotificationActionButton(
            key: 'check',
            label: 'Alarmı Kapat',
            actionType: ActionType.Default,
            showInCompactView: true,
            color: Colors.green,
          ),
        ],
        actionType: ActionType.Default,
        notificationLayout: NotificationLayout.BigText,
      );

      Get.offAll(
            () => const AppMain(),
        binding: AppBinding(),
        transition: Transition.zoom,
      );

      log(
        "Alarm ${entity.dateTime!.difference(DateTime.now()).inSeconds} saniye sonrasına kuruldu",
      );
    } catch (e) {
      Get.snackbar("Message", e.toString());
    }
  }

  DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }
}

SendPort? uiSendPort;

@pragma('vm:entry-point')
void callbackFunc() async {
  String? token;
  await SharedPreferences.getInstance().then((value) {
    value.reload();
    token = value.getString('filePath').toString();
    value.clear();
  });
  uiSendPort ??= IsolateNameServer.lookupPortByName("isolate");
  uiSendPort?.send(null);
  final audio = AudioPlayer();
  audio.setAudioSource(AudioSource.uri(Uri.parse(token.toString())));
  audio.setLoopMode(LoopMode.one);
  audio.play();
  log("Alarm Çalıyor");
  Future.delayed(const Duration(minutes: 1)).then((value) => audio.stop());
}
