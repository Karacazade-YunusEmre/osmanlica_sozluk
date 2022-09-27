import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/model/concrete/directory_model.dart';
import '/model/concrete/sentence_model.dart';
import '/utilities/enums.dart';
import '../main.dart';

/// Created by Yunus Emre Yıldırım
/// on 22.09.2022

class MainController extends GetxController {
  final sentenceList = <SentenceModel>[].obs;
  final directoryList = <DirectoryModel>[].obs;
  final _listSortCurrentValue = ListSortEnum.increase.obs;
  final _selectedDirectoryId = '1'.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    setupDirectoryList;
  }

  /// listSortCurrentValue getter
  ListSortEnum get listSortCurrentValue => _listSortCurrentValue.value;

  /// listSortCurrentValue setter
  set listSortCurrentValue(ListSortEnum newValue) => _listSortCurrentValue.value = newValue;

  /// selectedDirectoryId getter
  String get selectedDirectoryId => _selectedDirectoryId.value;

  /// selectedDirectoryId setter
  set selectedDirectoryId(String value) => _selectedDirectoryId.value = value;

  /// listSortCurrentValue change value
  void changelistSortCurrentValue(ListSortEnum? value) {
    if (value != null) {
      listSortCurrentValue = value;
    }
  }

  /// selectedDirectory change value
  void changeSelectedDirectory(String? newValue) {
    if (newValue != null) {
      selectedDirectoryId = newValue;
      debugPrint('Değer değişti. $newValue');
    }
  }

  /// directoryList setup on init
  Future<void> get setupDirectoryList async {
    List<DirectoryModel>? directoryListFromDatabase = [];
    directoryListFromDatabase.addAll(await directoryDal.getAll());

    if (directoryListFromDatabase.isEmpty) {
      DirectoryModel allListDirectory = DirectoryModel(id: '1', name: 'Tüm Kelimeler', sentenceCount: 0);
      DirectoryModel myFavoriteDirectory = DirectoryModel(id: '2', name: 'Favorilerim', sentenceCount: 0);

      directoryList.add(allListDirectory);
      directoryList.add(myFavoriteDirectory);
      directoryDal.add(allListDirectory);
      directoryDal.add(myFavoriteDirectory);
    } else {
      directoryList.addAll(directoryListFromDatabase);
    }
  }
}
