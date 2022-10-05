import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/main_controller.dart';

/// Created by Yunus Emre Yıldırım
/// on 9.09.2022

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> with SingleTickerProviderStateMixin {
  /// toggle == 1 is search bar expand, toggle == 0 is search bar collapse
  int toggle = 0;
  late TextEditingController textController;
  final double searchBarWidth = 0.5.sw;
  late Duration defaultAnimationDuration;
  late AnimationController animationController;
  late FocusNode focusNode;
  late MainController mainController;

  @override
  void initState() {
    super.initState();

    mainController = Get.find();
    textController = TextEditingController();
    defaultAnimationDuration = const Duration(milliseconds: 500);
    animationController = AnimationController(vsync: this, duration: defaultAnimationDuration);
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    animationController.dispose();
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return AnimatedContainer(
          duration: defaultAnimationDuration,
          width: toggle == 0 ? 32 : searchBarWidth,
          height: toggle == 0 ? 0.1.sh : 0.07.sh,
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: toggle == 0 ? Colors.transparent : Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          child: Stack(
            children: [
              ///#region clear button animated positioned
              AnimatedPositioned(
                duration: defaultAnimationDuration,
                right: 0,
                top: 0.01.sh,
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  duration: defaultAnimationDuration,
                  opacity: toggle == 0 ? 0.0 : 1.0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).secondaryHeaderColor,
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: AnimatedBuilder(
                        animation: animationController,
                        builder: (BuildContext context, Widget? child) {
                          return Transform.rotate(
                            angle: animationController.value * 2.0 * pi,
                            child: child,
                          );
                        },
                        child: InkWell(
                          onTap: () {
                            textController.clear();
                            mainController.loadSentenceListAccordingToDirectoryId();
                          },
                          child: const Icon(Icons.close, size: 24),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              ///#endregion clear button animated positioned

              ///#region search text animated positioned
              AnimatedPositioned(
                duration: defaultAnimationDuration,
                left: toggle == 0 ? 0 : 0.07.sw,
                top: 0.025.sh,
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  duration: defaultAnimationDuration,
                  opacity: toggle == 0 ? 0.0 : 1.0,
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    alignment: Alignment.topCenter,
                    width: searchBarWidth / 1.5,
                    child: TextField(
                      controller: textController,
                      autofocus: false,
                      focusNode: focusNode,
                      cursorRadius: const Radius.circular(10.0),
                      cursorWidth: 2.0,
                      onEditingComplete: () => textController.clear(),
                      onChanged: mainController.searchSentence,
                      textInputAction: TextInputAction.search,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white.withOpacity(0.5),
                      decoration: InputDecoration.collapsed(
                        // contentPadding: const EdgeInsets.only(bottom: 5),
                        // isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        // labelText: 'Kelime arayın ...',
                        // // labelStyle: const TextStyle(
                        // //   color: Color(0xff5B5B5B),
                        // //   fontSize: 17.0,
                        // //   fontWeight: FontWeight.w500,
                        // // ),
                        // alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Başlığa göre arayın...',
                      ),
                    ),
                  ),
                ),
              ),

              ///#endregion search text animated positioned

              ///#region search icon animated container
              AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget? child) {
                  return AnimatedPositioned(
                    duration: defaultAnimationDuration,
                    top: toggle == 0 ? 0.02.sh : 0.007.sh,
                    left: 0.0,
                    curve: Curves.easeInOut,
                    child: IconButton(
                      icon: AnimatedSwitcher(
                        duration: defaultAnimationDuration,
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return RotationTransition(
                            turns: child.key == const ValueKey('searchIcon') ? Tween<double>(begin: 1, end: 0.75).animate(animationController) : Tween<double>(begin: 0.75, end: 1).animate(animationController),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: toggle == 0
                            ? Icon(
                                Icons.search,
                                size: 32,
                                color: Theme.of(context).primaryColor,
                                key: const ValueKey('searchIcon'),
                              )
                            : Icon(
                                Icons.arrow_forward_ios,
                                size: 32,
                                color: Theme.of(context).secondaryHeaderColor,
                                key: const ValueKey('backIcon'),
                              ),
                      ),
                      onPressed: () {
                        if (toggle == 0) {
                          toggle = 1;
                          animationController.forward();
                          FocusManager.instance.primaryFocus?.requestFocus();
                        } else {
                          toggle = 0;
                          animationController.reverse();
                          textController.clear();
                          mainController.loadSentenceListAccordingToDirectoryId();
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                      },
                    ),
                  );
                },
              ),

              ///#endregion search icon animated container
            ],
          ),
        );
      },
    );
  }
}
