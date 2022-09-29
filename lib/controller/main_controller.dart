import 'package:cloud_firestore/cloud_firestore.dart';
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

    // await setupSentenceList;

    sentenceList.addAll(await sentenceDal.getAll());

    // if (sentenceList.isEmpty) {
    //   debugPrint('tablo boş');
    //   /// sentence list comes from firebase
    //   QuerySnapshot<Map<String, dynamic>> querySnapshot = await fireStore.collection('Sentence').get();
    //   for (QueryDocumentSnapshot<Map<String, dynamic>> item in querySnapshot.docs) {
    //     SentenceModel sentenceModel = SentenceModel(id: item.data()['id'], title: item.data()['title'], content: item.data()['content'], directoryId: '1');
    //     sentenceList.add(sentenceModel);
    //   }
    //
    //   sentenceDal.addAll(sentenceList);
    // }

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
    }
  }

  /// sentenceList setup on init
  Future<void> get setupSentenceList async {
    sentenceList.addAll(await sentenceDal.getAll());

    if (sentenceList.isEmpty) {
      debugPrint('tablo boş');
      /// sentence list comes from firebase
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await fireStore.collection('Sentence').get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> item in querySnapshot.docs) {
        SentenceModel sentenceModel = SentenceModel(id: item.data()['id'], title: item.data()['title'], content: item.data()['content'], directoryId: '1');
        sentenceList.add(sentenceModel);
      }

      sentenceDal.addAll(sentenceList);
    }
  }

  /// directoryList setup on init
  Future<void> get setupDirectoryList async {
    directoryList.addAll(await directoryDal.getAll());

    if (directoryList.isEmpty) {
      DirectoryModel allListDirectory = DirectoryModel(id: '1', name: 'Tüm Kelimeler', sentenceCount: 0);
      DirectoryModel myFavoriteDirectory = DirectoryModel(id: '2', name: 'Favorilerim', sentenceCount: 0);

      directoryList.addAll([allListDirectory, myFavoriteDirectory]);

      directoryDal.addAll(directoryList);
    }
  }
}
