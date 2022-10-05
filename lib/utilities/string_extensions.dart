/// Created by Yunus Emre Yıldırım
/// on 27.09.2022

extension StringExtensions on String {
  /// when directory create
  /// remove alphanumeric characters from directory name
  String get getFixDirectoryName {
    List<String> tempCharacters = [];
    RegExp regexp = RegExp(r'[a-zA-Z0-9öçşığüÖÇŞIĞÜ]+', multiLine: true);

    Iterable<RegExpMatch> matches = regexp.allMatches(toLowerCase());

    for (Match item in matches) {
      tempCharacters.add(item[0]!.toLowerCase());
    }

    String newValue = tempCharacters.join();
    newValue = newValue[0].toUpperCase() + newValue.substring(1).toLowerCase();

    return newValue;
  }

  /// remove alphanumeric characters
  /// from sentence title for searching
  String get fixingTextForSearching{
    List<String> tempCharacters = [];
    RegExp regExp = RegExp(r'[a-zA-Z0-9öçşığüÖÇŞIĞÜ]', multiLine: true);

    Iterable<RegExpMatch> matches = regExp.allMatches(toLowerCase());
    for (Match item in matches) {
      tempCharacters.add(item[0]!.toLowerCase());
    }
    return tempCharacters.join();
  }
}
