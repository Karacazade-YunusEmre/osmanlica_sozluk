import 'package:get/get.dart';

import '../main.dart';
import '/model/concrete/directory_model.dart';
import '/model/concrete/sentence_model.dart';
import '/utilities/enums.dart';

/// Created by Yunus Emre Yıldırım
/// on 22.09.2022

class MainController extends GetxController {
  final sentenceList = <SentenceModel>[].obs;
  final directoryList = <DirectoryModel>[].obs;
  final _listSortCurrentValue = ListSortEnum.increase.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    directoryList.addAll(await directoryDal.getAll());
  }

  /// listSortCurrentValue getter
  ListSortEnum get listSortCurrentValue => _listSortCurrentValue.value;

  /// listSortCurrentValue setter
  set listSortCurrentValue(ListSortEnum newValue) => _listSortCurrentValue.value = newValue;

  /// listSortCurrentValue change value
  void changelistSortCurrentValue(ListSortEnum? value) {
    if (value != null) {
      listSortCurrentValue = value;
    }
  }
}
