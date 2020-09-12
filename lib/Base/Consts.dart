import 'package:firstgame/Base/Enums.dart';

class DBConsts {
  //
  static const Games = "Games";
  static const Phases = "Phases";
  static const Players = "Players";
  static const Scores = "Scores";
  //
  static const WaitingRoom = "WaitingRoom";

  //
  static const Musics = "Musics";
}

String gDirToString(GDirections dir) {
  return dir.toString().replaceAll("GDirections.", "");
}

String gDirStringByIndex(int index) {
  return gDirToString(
      GDirections.values.firstWhere((element) => element.index == index));
}

GDirections stringToGDir(String dir) {
  return GDirections.values
      .firstWhere((element) => element.toString().contains(dir));
}

GDirections gDirByIndex(int index) {
  return GDirections.values.firstWhere(
    (element) => element.index == index,
    orElse: () => GDirections.None,
  );
}

extension toMap on dynamic {
  Map<dynamic, dynamic> get convertToMap {
    return Map.from(this);
  }
}

Map<String, dynamic> convertToMap(dynamic data) {
  return Map.from(data);
}

String phaseDataToString(int round, int beatPos) {
  return "R${round}P$beatPos";
}

PhaseData strDataToPhase(String data) {
  final rIndex = data.indexOf("R");
  final pIndex = data.indexOf("P");
  final round = int.parse(data.substring(rIndex + 1, pIndex));
  final phase = int.parse(data.substring(pIndex + 1, data.length));

  return PhaseData(beatPos: phase, round: round);
}

class PhaseData {
  int round;
  int beatPos;

  PhaseData({this.beatPos, this.round});
}
