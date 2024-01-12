import '../add-alarm/add_alarm_view.dart';
import '../add-alarm/add_alarm_view_controller.dart';
import '../info/info_screen.dart';
import '../home/home_controller.dart';
import '../home/home_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppController());
    Get.lazyPut(() => HomeController());
  }
}

class AppController extends GetxController {
  RxInt index = 0.obs;
  List<Widget> screens = [
    const HomeScreen(),
    const InfoScreen(),
  ];

  void onItemTapped(int i) {
    index.value = i;
  }

  void navigateAddAlarm() {
    Get.to(
      () => const AddAlarmView(),
      binding: AddAlarmViewBinding(),
      transition: Transition.cupertino,
    );
  }
}
