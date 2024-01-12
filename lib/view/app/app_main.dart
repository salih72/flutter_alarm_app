import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutteralarmapp/view/add-alarm/add_alarm_view.dart';
import 'package:flutteralarmapp/view/add-alarm/add_alarm_view_controller.dart';
import 'package:get/get.dart';

import 'app_controller.dart';

class AppMain extends StatelessWidget {
  const AppMain({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      initState: (state) {
        state.controller ?? Get.find<AppController>();
      },
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Mobil Programlama",
              style: TextStyle(
                fontSize: 25.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Get.to(
                    () => const AddAlarmView(),
                    binding: AddAlarmViewBinding(),
                    transition: Transition.cupertino,
                  );
                },
                child: Row(
                  children: [
                    Text(
                      "Alarm Ekle",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.add,
                      size: 20.sp,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
            backgroundColor: Colors.transparent,
          ),
          body: Obx(
            () {
              return controller.screens[controller.index.value];
            },
          ),
          bottomNavigationBar: Obx(
            () {
              return BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Ana Sayfa',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.info),
                    label: 'Emeği Geçenler',
                  ),
                ],
                currentIndex: controller.index.value,
                onTap: controller.onItemTapped,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey[400],
                backgroundColor: Colors.indigo,
                type: BottomNavigationBarType.fixed,
              );
            },
          ),
        );
      },
    );
  }
}
