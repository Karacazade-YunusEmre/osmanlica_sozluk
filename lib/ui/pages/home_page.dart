import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../components/widgets/sentence_list_widget.dart';
import '/main.dart';
import '/model/concrete/directory_model.dart';
import '/utilities/enums.dart';
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
              sentenceListWidget,
            ],
          ),
        ),
      ),

      /// directory add FAB
      floatingActionButton: FloatingActionButton(
        heroTag: 'directoryAddAndUpdate',
        onPressed: () => DirectoryAddUpdateDialog(currentDirectory: null),
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
        width: 1.sw,
        height: 1.sh,
        color: Theme.of(context).primaryColor,
        alignment: Alignment.centerLeft,
        child: Container(
          width: 0.6.sw,
          alignment: Alignment.center,
          child: Center(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: mainController.directoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  DirectoryModel currentDirectory = mainController.directoryList[index];
                  return Container(
                    height: (currentDirectory.id == '1' || currentDirectory.id == '2') ? 0.08.sh : 0.1.sh,
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: mainController.selectedDirectoryId == currentDirectory.id ? Colors.deepOrangeAccent : Colors.white,
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Stack(
                      children: [
                        /// directory item delete icon
                        Positioned(
                          top: 0,
                          right: 0,
                          child: (currentDirectory.id == '1' || currentDirectory.id == '2')
                              ? const SizedBox()
                              : IconButton(
                                  onPressed: () => removeDirectoryDialog(currentDirectory),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                ),
                        ),

                        /// sentences count in directory
                        Positioned(
                          top: (currentDirectory.id == '1' || currentDirectory.id == '2') ? 0.004.sh : 0.013.sh,
                          left: 0.01.sw,
                          child: Container(
                            width: 0.13.sw,
                            height: 0.13.sw,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(100)),
                              border: Border.all(
                                color: Colors.blue,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              currentDirectory.sentenceCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                // fontSize: 18,
                              ),
                            ),
                          ),
                        ),

                        /// directory item name
                        Positioned(
                          top: (currentDirectory.id == '1' || currentDirectory.id == '2') ? 0.02.sh : 0.03.sh,
                          left: 0.16.sw,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                mainController.changeSelectedDirectory(currentDirectory.id);
                              });
                            },
                            child: Text(
                              currentDirectory.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 74.sp,
                              ),
                            ),
                          ),
                        ),

                        /// directory item update icon
                        Positioned(
                          top: 0.04.sh,
                          right: 0,
                          child: (currentDirectory.id == '1' || currentDirectory.id == '2')
                              ? const SizedBox()
                              : IconButton(
                                  onPressed: () {
                                    menuToggle();
                                    DirectoryAddUpdateDialog(currentDirectory: currentDirectory);
                                  },
                                  icon: const Icon(
                                    Icons.update,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  /// sentence list widget
  Widget get sentenceListWidget {
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
                        onPressed: menuToggle,
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

                /// sentence list
                const SentenceListWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// when menu button clicked
  void menuToggle() {
    setState(() {
      if (isMenuOpen) {
        animationController.reverse();
      } else {
        animationController.forward();
      }
      defaultDashboardOpacity = defaultDashboardOpacity == 1 ? 0.6 : 1;
      isMenuOpen = !isMenuOpen;
    });
  }

  /// directory remove alert dialog
  void removeDirectoryDialog(DirectoryModel currentDirectory) {
    Get.defaultDialog(
      title: 'UYARI',
      middleText: 'Seçilen klasörü silmek istediğinizden emin misiniz?',
      backgroundColor: Colors.red.shade400,
      titleStyle: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      middleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      radius: 30,
      barrierDismissible: false,
      actions: [
        ElevatedButton(
          onPressed: () {
            mainController.directoryList.remove(currentDirectory);
            directoryDal.delete(currentDirectory);

            Get.back();
            Get.snackbar(
              'BİLGİ',
              'Klasör başarıyla silindi.',
              borderColor: Colors.red,
              borderWidth: 2,
              snackPosition: SnackPosition.BOTTOM,
              maxWidth: 0.8.sw,
            );
          },
          child: const Text('EVET'),
        ),
        ElevatedButton(
          onPressed: () => Get.back(),
          child: const Text('HAYIR'),
        ),
      ],
    );
  }
}
