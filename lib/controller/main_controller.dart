import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/utilities/string_extensions.dart';
import '/model/concrete/directory_model.dart';
import '/model/concrete/sentence_model.dart';
import '/utilities/enums.dart';
import '../main.dart';

/// Created by Yunus Emre Yıldırım
/// on 22.09.2022

class MainController extends GetxController {
  final selectedDirectoryBox = GetStorage();
  final fixedSentenceList = <SentenceModel>[];
  final fixedDirectoryList = <DirectoryModel>[];

  final sentenceList = <SentenceModel>[].obs;
  final directoryList = <DirectoryModel>[].obs;

  final _listSortCurrentValue = ListSortEnum.increase.obs;
  final _selectedDirectoryId = ''.obs;
  final _selectedDirectoryName = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    await setupSentenceList();
    await setupDirectoryList();
    setupSelectedDirectoryId();
    setupSelectedDirectoryName();
  }

  ///#region getter and setter

  /// listSortCurrentValue getter
  ListSortEnum get listSortCurrentValue => _listSortCurrentValue.value;

  /// listSortCurrentValue setter
  set listSortCurrentValue(ListSortEnum newValue) => _listSortCurrentValue.value = newValue;

  /// selectedDirectoryId getter
  String get selectedDirectoryId => _selectedDirectoryId.value;

  /// selectedDirectoryId setter
  set selectedDirectoryId(String value) => _selectedDirectoryId.value = value;

  /// selectedDirectoryName getter
  String get selectedDirectoryName => _selectedDirectoryName.value;

  /// selectedDirectoryName setter
  set selectedDirectoryName(String? newValue) => _selectedDirectoryName.value = newValue!;

  ///#endregion getter and setter

  ///#region setup methods

  /// sentenceList setup on init
  Future<void> setupSentenceList() async {
    fixedSentenceList.addAll(await sentenceDal.getAll());

    if (fixedSentenceList.isEmpty) {
      List<SentenceModel>? tempSentenceList = await firebaseStorageService.getAll();
      if (tempSentenceList != null) {
        fixedSentenceList.addAll(tempSentenceList);
        sentenceDal.addAll(fixedSentenceList);
      }
    }
    sentenceList.addAll(fixedSentenceList);
  }

  /// directoryList setup on init
  Future<void> setupDirectoryList() async {
    fixedDirectoryList.addAll(await directoryDal.getAll());

    if (fixedDirectoryList.isEmpty) {
      int sentenceListCount = sentenceList.length;
      DirectoryModel allListDirectory = DirectoryModel(id: '1', name: 'Tüm Kelimeler', sentenceCount: sentenceListCount);
      DirectoryModel myFavoriteDirectory = DirectoryModel(id: '2', name: 'Favorilerim', sentenceCount: 0);

      fixedDirectoryList.addAll([allListDirectory, myFavoriteDirectory]);
      directoryDal.addAll(fixedDirectoryList);
    }
    directoryList.addAll(fixedDirectoryList);
  }

  /// setup selected directory Id
  void setupSelectedDirectoryId() {
    String? directoryId = selectedDirectoryBox.read('selectedDirectoryId');
    if (directoryId != null) {
      selectedDirectoryId = directoryId;
    } else {
      selectedDirectoryId = '1';
    }
  }

  /// setup selected directory name for title
  void setupSelectedDirectoryName() {
    String? directoryId = selectedDirectoryBox.read('selectedDirectoryId');

    if (directoryId != null) {
      DirectoryModel selectedDirectory = directoryList.firstWhere((directory) => directory.id == directoryId);
      selectedDirectoryName = selectedDirectory.name;
    } else {
      selectedDirectoryName = 'Tüm Kelimeler';
    }
  }

  ///#endregion setup methods

  ///#region event methods

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

  /// sort the list in descending order
  void sortListDescending() {
    sentenceList.sort((a, b) => a.title.compareTo(b.title));
  }

  /// sort the list in ascending order
  void sortListAscending() {
    sentenceList.sort((a, b) => b.title.compareTo(a.title));
  }

  /// search bar value changed
  void searchSentence(String? query) {
    List<SentenceModel> filteredList = [];
    if (query == null || query.isEmpty) {
      filteredList.addAll(fixedSentenceList);
    } else {
      filteredList = [];
      filteredList = fixedSentenceList.where((element) => element.title.fixingTextForSearching.contains(query.fixingTextForSearching)).toList();
    }
    sentenceList.clear();
    sentenceList.addAll(filteredList);
  }

  ///#region selectedDirectory change value
  void changeSelectedDirectory(String? newValue) {
    if (newValue != null) {
      selectedDirectoryId = newValue;
      _loadSentenceListAccordingToDirectoryId();

      /// save selected directory id
      selectedDirectoryBox.write('selectedDirectoryId', newValue);

      DirectoryModel selectedDirectory = directoryList.firstWhere((element) => element.id == newValue);

      /// set selected directory name for title
      selectedDirectoryName = selectedDirectory.name;
    }
  }
  ///#endregion

  ///#region load sentenceList according to selectedDirectoryId
  void _loadSentenceListAccordingToDirectoryId() {
    List<SentenceModel> newList = [];

    for (SentenceModel item in fixedSentenceList) {
      if (item.directoryId == selectedDirectoryId) {
        newList.add(item);
      }
    }
    sentenceList.clear();
    sentenceList.addAll(newList);
  }
  ///#endregion

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

  ///#endregion event methods

}
