import 'package:firstgame/Base/Enums.dart';

class DBConsts {
  //
  static const Games = "Games";
  static const Phases = "Phases";
  static const Players = "Players";
  static const Scores = "Scores";
  //
  static const WaitingRoom = "WaitingRoom";
}

String gDirToString(GDirections dir) {
  return dir.toString().replaceAll("GDirections.", "");
}

GDirections stringToGDir(String dir) {
  return GDirections.values
      .firstWhere((element) => element.toString().contains(dir));
}
