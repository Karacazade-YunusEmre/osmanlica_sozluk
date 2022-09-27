import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '/controller/main_controller.dart';
import '/repository/base/i_directory_repository.dart';
import '/repository/base/i_sentence_repository.dart';
import '/repository/sqlite/directory_dal.dart';
import '/ui/pages/page_not_found.dart';
import 'repository/sqlite/sentence_dal.dart';
import 'utilities/router.dart';
import 'utilities/ui_constant.dart';

late ISentenceRepository sentenceDal;
late IDirectoryRepository directoryDal;

void main() async {
  init;
  setupLocators;
  initControllers;
  runApp(const MainApp());
}

void get init {
  WidgetsFlutterBinding.ensureInitialized();
}

void get setupLocators {
  final sentenceLocator = GetIt.instance;
  final directoryLocator = GetIt.instance;

  sentenceLocator.registerSingleton<ISentenceRepository>(SentenceDal());
  directoryLocator.registerSingleton<IDirectoryRepository>(DirectoryDal());

  sentenceDal = sentenceLocator<ISentenceRepository>();
  directoryDal = directoryLocator<IDirectoryRepository>();
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
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Risale-i Nur Lugat',
          theme: UIConstant.getDefaultThemeData,
          getPages: routes,
          unknownRoute: GetPage(
            name: '/pageNotFound',
            page: () => const PageNotFound(),
          ),
        );
      },
    );
  }
}
