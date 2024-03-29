import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'feature/init/app/app_init.dart';
import 'feature/services/route/route_service.dart';

Future<void> main() async {
  await AppInitiliaze().initBeforeAppStart();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          initialRoute: RouteService.getSplashRoute(),
          getPages: RouteService.routes,
        );
      },
    );
  }
}

/*
git add .
git commit -m "<your commit is here>"
git push origin <branchName>
 */
//