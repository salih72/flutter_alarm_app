import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../feature/models/alarm_model.dart';
import '../../feature/services/database/alarm_database_provider.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<AlarmModel> alarms = <AlarmModel>[].obs;
  final database = AlarmDatabaseProvider.instance;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String alarmTitle = '';
  int notificationMinutes = 5;

  void isLoadingChange() {
    isLoading.value = !isLoading.value;
  }

  Future<void> getAlarm() async {
    isLoadingChange();
    var dbAlarms = await database.getAll();
    if (dbAlarms != null) {
      alarms.value = dbAlarms;
    }
    isLoadingChange();
  }

  Future<void> checkDatabaseForNewAlarms() async {
    isLoadingChange();
    var dbAlarms = await database.getAll();
    if (dbAlarms?.length != alarms.length) {
      getAlarm();
    }
    isLoadingChange();
  }

  @override
  void onInit() {
    getAlarm();
    super.onInit();
  }

  Future<void> deleteAlarm(AlarmModel alarm) async {
    alarms.removeWhere((element) => element == alarm);
    await database.delete(alarm.id!);
  }

  void showEditAlertDialog(AlarmModel alarm) {
    TextEditingController titleController =
        TextEditingController(text: alarm.title);

    Get.defaultDialog(
      backgroundColor: Colors.white,
      title: "Alarm Düzenle",
      content: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Alarm Başlığı",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await selectDate();
                },
                child: const Text("Tarih Seç"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  await selectTime();
                },
                child: const Text("Saat Seç"),
              ),
            ],
          ),
        ],
      ),
      textCancel: "İptal",
      textConfirm: "Kaydet",
      onCancel: () {
        Get.back();
      },
      onConfirm: () {
        alarm.title = titleController.text;
        alarm.dateTime = selectedDate == null || selectedTime == null
            ? alarm.dateTime
            : combineDateAndTime(selectedDate!, selectedTime!);
        database.update(alarm.id!, alarm);
        update();
        Get.back();
      },
    );
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

  DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  Future<void> onRefresh() async {
    alarms.clear();
    getAlarm();
  }
}
