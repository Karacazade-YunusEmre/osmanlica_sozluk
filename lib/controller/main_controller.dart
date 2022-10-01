import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/model/concrete/directory_model.dart';
import '/model/concrete/sentence_model.dart';
import '/utilities/enums.dart';
import '../main.dart';

/// Created by Yunus Emre Yıldırım
/// on 22.09.2022

class MainController extends GetxController {
  final selectedDirectoryBox = GetStorage();
  final fixedSentenceList = <SentenceModel>[];

  final sentenceList = <SentenceModel>[].obs;
  final directoryList = <DirectoryModel>[].obs;
  final _listSortCurrentValue = ListSortEnum.increase.obs;
  final _selectedDirectoryId = '1'.obs;
  final _titleSelectedDirectoryName = 'Tüm Kelimeler'.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    setupSelectedDirectoryId();
    setupSelectedDirectoryName();
    setupSentenceList();
    setupDirectoryList();
  }

  /// listSortCurrentValue getter
  ListSortEnum get listSortCurrentValue => _listSortCurrentValue.value;

  /// listSortCurrentValue setter
  set listSortCurrentValue(ListSortEnum newValue) => _listSortCurrentValue.value = newValue;

  /// selectedDirectoryId getter
  String get selectedDirectoryId => _selectedDirectoryId.value;

  /// selectedDirectoryId setter
  set selectedDirectoryId(String value) => _selectedDirectoryId.value = value;

  /// titleSelectedDirectoryName getter
  String get titleSelectedDirectoryName => _titleSelectedDirectoryName.value;

  /// titleSelectedDirectoryName setter
  set titleSelectedDirectoryName(String? newValue) => _titleSelectedDirectoryName.value = newValue!;

  /// listSortCurrentValue change value
  void changelistSortDirection(ListSortEnum? value) {
    if (value != null) {
      listSortCurrentValue = value;

      if (value == ListSortEnum.increase) {
        sortListAscending();
      } else if (value == ListSortEnum.decrease) {
        sortListDescending();
      }
    }
  }

  /// selectedDirectory change value
  void changeSelectedDirectory(String? newValue) {
    if (newValue != null) {
      loadSentenceList(newValue);

      /// save selected directory id
      selectedDirectoryBox.write('selectedDirectoryId', newValue);

      /// save selected directory name
      DirectoryModel currentDirectory = directoryList.firstWhere((element) => element.id == selectedDirectoryId);
      selectedDirectoryBox.write('selectedDirectoryName', currentDirectory.name);

      /// set selected directory name for title
      titleSelectedDirectoryName = currentDirectory.name;
    }
  }

  /// load sentenceList according to selectedDirectoryId
  void loadSentenceList(String newValue) {
    selectedDirectoryId = newValue;
    List<SentenceModel> newList = [];

    for (SentenceModel item in fixedSentenceList) {
      if (item.directoryId == selectedDirectoryId) {
        newList.add(item);
      }
    }
    sentenceList.clear();
    sentenceList.addAll(newList);
  }

  /// sentenceList setup on init
  Future<void> setupSentenceList() async {
    fixedSentenceList.addAll(await sentenceDal.getAll());
    if (fixedSentenceList.isEmpty) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await fireStore.collection('Sentence').get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> item in querySnapshot.docs) {
        SentenceModel sentenceModel = SentenceModel(id: item.data()['id'], title: item.data()['title'], content: item.data()['content'], directoryId: '1');
        fixedSentenceList.add(sentenceModel);
      }
      sentenceDal.addAll(fixedSentenceList);
    }
    loadSentenceList(selectedDirectoryId);
    // sentenceList.addAll(fixedSentenceList);
  }

  /// directoryList setup on init
  Future<void> setupDirectoryList() async {
    directoryList.addAll(await directoryDal.getAll());

    if (directoryList.isEmpty) {
      DirectoryModel allListDirectory = DirectoryModel(id: '1', name: 'Tüm Kelimeler', sentenceCount: sentenceList.length);
      DirectoryModel myFavoriteDirectory = DirectoryModel(id: '2', name: 'Favorilerim', sentenceCount: 0);

      directoryList.addAll([allListDirectory, myFavoriteDirectory]);

      directoryDal.addAll(directoryList);
    }
  }

  /// change sentence in directory
  void changeSentenceInCurrentDirectory({required SentenceModel currentSentence, required DirectoryModel newDirectory}) {
    DirectoryModel oldDirectory = directoryList.firstWhere((element) => element.id == currentSentence.directoryId);
    currentSentence.directoryId = newDirectory.id;
    oldDirectory.sentenceCount--;
    newDirectory.sentenceCount++;

    sentenceDal.update(currentSentence);
    directoryDal.update(oldDirectory);
    directoryDal.update(newDirectory);
  }

  /// setup selected directory Id
  void setupSelectedDirectoryId() {
    String? directoryId = selectedDirectoryBox.read('selectedDirectoryId');
    if (directoryId != null) {
      selectedDirectoryId = directoryId;
    }
  }

  /// setup selected directory name for title
  void setupSelectedDirectoryName() {
    String? selectedDirectoryName = selectedDirectoryBox.read('selectedDirectoryName');

    if (selectedDirectoryName != null) {
      titleSelectedDirectoryName = selectedDirectoryName;
    }
  }

  /// sort the list in descending order
  void sortListDescending() {
    sentenceList.sort((a, b) => a.title.compareTo(b.title));
  }

  /// sort the list in ascending order
  void sortListAscending() {
    sentenceList.sort((a, b) => b.title.compareTo(a.title));
  }
}
