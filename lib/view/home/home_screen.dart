import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutteralarmapp/feature/components/card/home_item_card.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      initState: (state) {
        state.controller ?? Get.find<HomeController>();
        state.controller?.onInit();
      },
      builder: (controller) {
        return buildBody(controller);
      },
    );
  }

  Widget buildBody(HomeController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.onRefresh(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Obx(
            () {
              if (controller.isLoading.isTrue) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (controller.alarms.isEmpty) {
                return const Center(child: Text("Yaklaşan Alarmınız yok."));
              }

              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.alarms.length,
                padding: EdgeInsets.all(8.sp),
                itemBuilder: (context, index) {
                  var alarm = controller.alarms[index];
                  return HomeItemCard(
                    alarm: alarm,
                    onTap: () {
                      controller.showEditAlertDialog(alarm);
                    },
                    onDismissed: (direction) async {
                      Get.snackbar(
                        "${alarm.title}",
                        "Alarm silindi",
                        backgroundColor: Colors.yellow,
                      );
                      await controller.deleteAlarm(alarm);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
