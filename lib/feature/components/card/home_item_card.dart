import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutteralarmapp/feature/models/alarm_model.dart';
import 'package:flutteralarmapp/view/show-alarm/show_alarm_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeItemCard extends StatelessWidget {
  const HomeItemCard(
      {super.key, required this.alarm, this.onTap, this.onDismissed});
  final AlarmModel alarm;
  final void Function()? onTap;
  final void Function(DismissDirection)? onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(alarm.id.toString()),
      onDismissed: onDismissed,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        color: Colors.white,
        child: ListTile(
          onLongPress: () => Get.to(() => const ShowAlarmView()),
          onTap: onTap,
          leading: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.indigo,
            child: Icon(
              Icons.alarm,
              color: Colors.white,
            ),
          ),
          title: Text(
            '${alarm.title}',
            style: TextStyle(fontSize: 30.sp),
          ),
          trailing: Text(
            DateFormat("dd-MM-yyyy").format(alarm.dateTime!),
          ),
          subtitle: Column(
            children: [
              Text(
                alarm.dateTime!.difference(DateTime.now()).inMinutes < 0
                    ? "Alarmınızın süresi geçti"
                    : "Alarmınızın Süresine ${alarm.dateTime!.difference(DateTime.now()).inMinutes} dakika kaldı",
              ),
              Text(
                "Düzenle",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
