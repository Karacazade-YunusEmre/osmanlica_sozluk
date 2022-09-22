import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lugat/controller/main_controller.dart';

import 'utilities/router.dart';
import 'utilities/ui_constant.dart';

void main() {
  initControllers;
  runApp(const MainApp());
}

void get initControllers {
  Get.put(MainController());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 2960),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Risale-i Nur Lugat',
          theme: UIConstant.getDefaultThemeData,
          routerDelegate: router.routerDelegate,
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
        );
      },
    );
  }
}
