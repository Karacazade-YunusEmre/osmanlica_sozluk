import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lugat/utilities/enums.dart';

import '../../controller/main_controller.dart';

/// Created by Yunus Emre Yıldırım
/// on 22.09.2022

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MainController mainController;
  late Duration defaultAnimationDuration;

  @override
  void initState() {
    super.initState();

    mainController = Get.find();
    defaultAnimationDuration = const Duration(milliseconds: 500);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Stack(
            children: [
              menuWidget,
              dashboardWidget,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Liste Ekle',
        child: const Icon(Icons.add_chart_outlined),
      ),
    );
  }

  /// menu widget
  Widget get menuWidget {
    return Container();
  }

  /// dashboard widget
  Widget get dashboardWidget {
    return AnimatedPositioned(
      duration: defaultAnimationDuration,
      top: 0,
      bottom: 0,
      left: mainController.isMenuOpen ? 0.4.sw : 0,
      right: mainController.isMenuOpen ? -0.6.sw : 0,
      curve: Curves.linear,
      child: Material(
        elevation: 0.1.sh,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(mainController.isMenuOpen ? 20 : 0)),
        child: Column(
          children: [
            /// appbar
            Container(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// menu icon
                  IconButton(
                    onPressed: mainController.changeIsMenuOpen,
                    icon: const Icon(Icons.menu),
                  ),

                  /// list sort popup menu
                  PopupMenuButton<ListSortEnum>(
                    initialValue: mainController.listSortCurrentValue,
                    offset: const Offset(100, 50),
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
    );
  }
}
