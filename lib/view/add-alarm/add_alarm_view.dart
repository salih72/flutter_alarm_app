import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'add_alarm_view_controller.dart';
import 'package:get/get.dart';

class AddAlarmView extends StatelessWidget {
  const AddAlarmView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddAlarmViewController>(
      init: AddAlarmViewController(),
      builder: (controller) {
        return buildScaffold(context, controller);
      },
    );
  }

  Scaffold buildScaffold(
      BuildContext context, AddAlarmViewController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm Ekleme Sayfası'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          buildTextField(
            'Açıklama',
            'Açıklama',
                (value) => controller.onAlarmTitleChanged(value),
            Colors.indigo,
          ),
          const SizedBox(height: 16.0),
          buildElevatedButton(
            'Tarih Seç',
            controller.selectedDate == null
                ? 'Tarih Seç'
                : 'Seçilen Tarih: ${controller.selectedDate!.toIso8601String().split('T')[0]}',
                () => controller.selectDate(),
            Colors.indigo,
          ),
          const SizedBox(height: 16.0),
          buildElevatedButton(
            'Saati Seç',
            controller.selectedTime == null
                ? 'Saati Seçiniz'
                : 'Seçilen Saat: ${controller.selectedTime!.format(context)}',
                () => controller.selectTime(),
            Colors.indigo,
          ),
          const SizedBox(height: 16.0),
          buildInputContainer(
            'Zil Sesi Seç',
            controller.selectedRingtone.value.isEmpty
                ? 'Zil Sesi Seç'
                : 'Selected Ringtone: ${controller.selectedRingtone}',
                () => controller.pickRingtone(context),
            Colors.indigo,
          ),
          const SizedBox(height: 16.0),
          buildDropdownButton(
            'Bildirim Süresi',
            [5, 10, 15, 30, 60],
            controller.notificationMinutes,
                (int? value) => controller.onNotificationMinutesChanged(value),
            Colors.indigo,
          ),
          const SizedBox(height: 32.0),
          buildSaveButton(() {
            controller.saveRingtone();
          }),
        ],
      ),
    );
  }

  ElevatedButton buildElevatedButton(String labelText, String buttonText,
      VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Center(
        child: Text(buttonText,
            style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  Container buildInputContainer(String labelText, String buttonText,
      VoidCallback onPressed, Color color) {
    return Container(
      width: 360.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.white),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(buttonText,
            style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  Widget buildTextField(String labelText, String hintText,
      ValueChanged<String> onChanged, Color color) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
      ),
    );
  }

  Widget buildDropdownButton(String labelText, List<int> items, int? value,
      ValueChanged<int?> onChanged, Color color) {
    return DropdownButtonFormField(
      items: items
          .map((minutes) => DropdownMenuItem(
        value: minutes,
        child: Text('$minutes Dakika Önce'),
      ))
          .toList(),
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
      ),
      onChanged: onChanged,
    );
  }

  Container buildSaveButton(VoidCallback onPressed) {
    return Container(
      width: 360.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(5),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: const Text(
          "Kaydet",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
