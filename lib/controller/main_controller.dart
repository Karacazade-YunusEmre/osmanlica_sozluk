import 'package:get/get.dart';
import 'package:lugat/utilities/enums.dart';

/// Created by Yunus Emre Yıldırım
/// on 22.09.2022

class MainController extends GetxController {
  final _listSortCurrentValue = ListSortEnum.increase.obs;
  final _isMenuOpen = false.obs;

  /// listSortCurrentValue getter
  ListSortEnum get listSortCurrentValue => _listSortCurrentValue.value;

  /// listSortCurrentValue setter
  set listSortCurrentValue(ListSortEnum newValue) => _listSortCurrentValue.value = newValue;

  /// isMenuOpen getter
  bool get isMenuOpen => _isMenuOpen.value;

  /// isMenuOpen setter
  set isMenuOpen(bool newValue) => _isMenuOpen.value = newValue;

  /// listSortCurrentValue change value
  void changelistSortCurrentValue(ListSortEnum? value) {
    if (value != null) {
      listSortCurrentValue = value;
    }
  }

  /// isMenuOpen change value
  void changeIsMenuOpen() {
    isMenuOpen = !isMenuOpen;
  }
}
