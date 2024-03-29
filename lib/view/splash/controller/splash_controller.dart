import 'package:get/get.dart';

import '../../../feature/services/route/route_service.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(
      const Duration(microseconds: 1),
      () async {
        /* bool hasConnection = await InternetConnectionChecker().hasConnection;
        if (hasConnection == true) {
          Get.offNamed(RouteService.app);
        } else {
          Get.offNamed(RouteService.error);
        } */

        Get.offNamed(RouteService.app);
      },
    );
    super.onInit();
  }
}
