import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lugat/model/concrete/directory_model.dart';
import 'package:lugat/utilities/enums.dart';

import '../../controller/main_controller.dart';
import '../components/dialogs/directory_add_update_dialog.dart';

/// Created by Yunus Emre Yıldırım
/// on 22.09.2022

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late MainController mainController;
  late Duration defaultAnimationDuration;
  late AnimationController animationController;
  late Animation<double> animationScale;
  late Animation<double> animationBorderRadius;
  late Animation<Offset> animationSlide;

  bool isMenuOpen = false;
  double defaultDashboardOpacity = 1;

  @override
  void initState() {
    super.initState();

    mainController = Get.find();
    defaultAnimationDuration = const Duration(milliseconds: 500);
    animationController = AnimationController(vsync: this, duration: defaultAnimationDuration);
    animationScale = Tween<double>(begin: 1.0, end: 0.6).animate(animationController);
    animationBorderRadius = Tween<double>(begin: 0.5, end: 0).animate(animationController);
    animationSlide = Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0)).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Stack(
            children: [
              directoryListWidget,
              dashboardWidget,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'directoryAddAndUpdate',
        onPressed: () => DirectoryAddUpdateDialog(),
        tooltip: 'Klasör Ekle',
        child: const Icon(Icons.add_chart_outlined),
      ),
    );
  }

  /// directory list widget
  Widget get directoryListWidget {
    return SlideTransition(
      position: animationSlide,
      child: Container(
        // width: 1.sw,
        // height: 1.sh,
        color: const Color(0XFF333340),
        child: ListView.builder(
            itemCount: mainController.directoryList.length,
            itemBuilder: (BuildContext context, int index) {
              DirectoryModel currentDirectory = mainController.directoryList[index];
              return Container(
                height: 0.07.sh,
                width: 0.5.sw,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2,),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      top: 0.015.sh,
                      left: 0.15.sw,
                      child: Text(
                        currentDirectory.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 74.sp,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0.5.sw,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.update,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  /// dashboard widget
  Widget get dashboardWidget {
    return AnimatedPositioned(
      duration: defaultAnimationDuration,
      top: 0,
      bottom: 0,
      left: isMenuOpen ? 0.4.sw : 0,
      right: isMenuOpen ? -0.6.sw : 0,
      curve: Curves.linear,
      child: ScaleTransition(
        scale: animationScale,
        child: AnimatedOpacity(
          duration: defaultAnimationDuration,
          opacity: defaultDashboardOpacity,
          child: Material(
            elevation: 0.1.sw,
            shadowColor: Colors.black,
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(isMenuOpen ? animationBorderRadius.value * 100 : 0)),
            child: Column(
              children: [
                /// appbar
                Container(
                  height: 0.1.sh,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(isMenuOpen ? animationBorderRadius.value * 100 : 0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// menu icon
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (isMenuOpen) {
                              animationController.reverse();
                            } else {
                              animationController.forward();
                            }
                            defaultDashboardOpacity = defaultDashboardOpacity == 1 ? 0.6 : 1;
                            isMenuOpen = !isMenuOpen;
                          });
                        },
                        icon: const Icon(
                          Icons.menu,
                          size: 34,
                        ),
                      ),

                      /// list sort popup menu
                      PopupMenuButton<ListSortEnum>(
                        initialValue: mainController.listSortCurrentValue,
                        offset: const Offset(100, 50),
                        iconSize: 34,
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem<ListSortEnum>(
                              value: ListSortEnum.increase,
                              child: Text('Sırala (A-Z)'),
                            ),
                            const PopupMenuItem<ListSortEnum>(
                              value: ListSortEnum.decrease,
                              child: Text('Sırala (Z-A)'),
                            ),
                          ];
                        },
                        onSelected: mainController.changelistSortCurrentValue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
