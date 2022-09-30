import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../../controller/main_controller.dart';
import '../../../model/concrete/sentence_model.dart';
import 'sentence_item_widget.dart';

/// Created by Yunus Emre Yıldırım
/// on 28.09.2022

class SentenceListWidget extends StatefulWidget {
  const SentenceListWidget({Key? key}) : super(key: key);

  @override
  State<SentenceListWidget> createState() => _SentenceListWidgetState();
}

class _SentenceListWidgetState extends State<SentenceListWidget> {
  late MainController mainController;

  @override
  void initState() {
    super.initState();

    mainController = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => mainController.sentenceList.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepOrangeAccent,
                  ),
                )
              : AnimationLimiter(
                  child: ListView.builder(
                    itemCount: mainController.sentenceList.length,
                    itemBuilder: (BuildContext context, int index) {
                      SentenceModel currentSentence = mainController.sentenceList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: SentenceItemWidget(currentSentence: currentSentence),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
