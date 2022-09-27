/// Created by Yunus Emre Yıldırım
/// on 27.09.2022

extension StringExtensions on String {
  String get getFixDirectoryName {
    List<String> tempCharacters = [];
    RegExp regexp = RegExp(r'[a-zA-Z0-9]+', multiLine: true);

    Iterable<RegExpMatch> matches = regexp.allMatches(toLowerCase());

    for (Match item in matches) {
      tempCharacters.add(item[0]!.toLowerCase());
    }

    String newValue = tempCharacters.join();
    newValue = newValue[0].toUpperCase() + newValue.substring(1).toLowerCase();

    return newValue;
  }
}
