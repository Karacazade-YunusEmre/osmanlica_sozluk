import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../components/widgets/search_bar_widget.dart';
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
  late Animation<double> animationOpacity;

  bool isMenuOpen = false;

  @override
  void initState() {
    super.initState();

    mainController = Get.find();
    defaultAnimationDuration = const Duration(milliseconds: 500);
    animationController = AnimationController(vsync: this, duration: defaultAnimationDuration);
    animationScale = Tween<double>(begin: 1.0, end: 0.6).animate(animationController);
    animationBorderRadius = Tween<double>(begin: 0, end: 0.5).animate(animationController);
    animationSlide = Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0)).animate(animationController);
    animationOpacity = Tween<double>(begin: 1.0, end: 0.6).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            directoryListWidget,
            sentenceListWidget,
          ],
        ),
      ),

      ///#region FAB directory add

      floatingActionButton: FloatingActionButton(
        heroTag: 'directoryAddAndUpdate',
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        onPressed: () => DirectoryAddUpdateDialog(currentDirectory: null),
        tooltip: 'Klasör Ekle',
        child: Icon(
          Icons.add_chart_outlined,
          color: Theme.of(context).primaryColor,
        ),
      ),

      ///#endregion FAB directory add
    );
  }

  ///#region directory list widget
  Widget get directoryListWidget {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
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
                child: Obx(
                  () => ListView.builder(
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
                            ///#region current directory remove icon
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

                            ///#endregion current directory remove icon

                            ///#region current directory sentence count
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
                                    color: Theme.of(context).secondaryHeaderColor,
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

                            ///#endregion

                            ///#region current directory name
                            Positioned(
                              top: (currentDirectory.id == '1' || currentDirectory.id == '2') ? 0.02.sh : 0.03.sh,
                              left: 0.16.sw,
                              child: InkWell(
                                onTap: () {
                                  mainController.changeSelectedDirectory(currentDirectory.id);
                                  menuToggle();
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

                            ///#endregion

                            ///#region current directory update icon
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

                            ///#endregion
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ///#endregion

  ///#region sentence list widget
  Widget get sentenceListWidget {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
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
              opacity: animationOpacity.value,
              child: AnimatedContainer(
                duration: defaultAnimationDuration,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(animationBorderRadius.value * 50)),
                ),
                child: Column(
                  children: [
                    ///#region appbar
                    Container(
                      height: 0.1.sh,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///#region menu button and title row
                          Row(
                            children: [
                              ///#region menu icon
                              IconButton(
                                onPressed: menuToggle,
                                icon: const Icon(
                                  Icons.menu,
                                  size: 34,
                                ),
                              ),

                              ///#endregion menu icon

                              ///#region selected directory name title
                              Obx(
                                () => Text(
                                  mainController.selectedDirectoryName,
                                  style: TextStyle(
                                    fontSize: 60.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),

                              ///#endregion selected directory name title
                            ],
                          ),

                          ///#endregion menu button and title row

                          ///#region search button and sort popupmenu row
                          Row(
                            children: [
                              /// search bar widget
                              const SearchBarWidget(),

                              ///#region list sort popup menu
                              Obx(
                                () => PopupMenuButton<ListSortEnum>(
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
                                  onSelected: mainController.changelistSortDirection,
                                ),
                              ),

                              ///#endregion list sort popup menu
                            ],
                          ),

                          ///#endregion search button and sort popupmenu row
                        ],
                      ),
                    ),

                    ///#endregion appbar

                    /// sentence list
                    const SentenceListWidget(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ///endregion

  ///#region event methods

  ///#region menu toggle event method
  void menuToggle() {
    if (isMenuOpen) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
    isMenuOpen = !isMenuOpen;
  }

  ///#endregion

  ///#region remove directory alert dialog
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
            mainController.removeDirectory(currentDirectory);

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

  ///#endregion

  ///#endregion

}
