import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firstgame/Base/Consts.dart';
import 'package:firstgame/Base/Enums.dart';
import 'package:firstgame/models/GameModel.dart';

class GameService {
  GameModel gameModel;

  final _ser = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance;
  User get me => _ser.currentUser;
  GameService({this.gameModel});

  Future<GameModel> get gameData async {
    final x = (await _db
            .reference()
            .child(DBConsts.Games)
            .child(gameModel.uid)
            .once())
        .value;
    final map = convertToMap(x);
    return GameModel.fromJson(map);
  }

  saveDirection(String phase, GDirections dir) async {
    if (me == null) await _ser.signInAnonymously();
    _db
        .reference()
        .child(DBConsts.Games)
        .child(gameModel.uid)
        .child(DBConsts.Phases)
        .child(me.uid)
        .update({phase: dir.index});

    // //TODO TEST

    // _db
    //     .reference()
    //     .child(DBConsts.Games)
    //     .child(gameModel.uid)
    //     .child(DBConsts.Phases)
    //     .child(p2Uid)
    //     .update({phase: dir.index});
  }

  Stream get myData {
    return _db
        .reference()
        .child(DBConsts.Games)
        .child(gameModel.uid)
        .child(DBConsts.Phases)
        .child(me.uid)
        .onValue
        .map((event) => event.snapshot.value);
  }

  String get p2Uid {
    return gameModel.amITheOwner(me.uid) ? gameModel.player2 : gameModel.owner;
  }

  Future get player2DataFuture async {
    return (await _db
            .reference()
            .child(DBConsts.Games)
            .child(gameModel.uid)
            .child(DBConsts.Phases)
            .child(p2Uid)
            .once())
        .value;
  }

  Future<void> clearRoom() async {
    await _db
        .reference()
        .child(DBConsts.Games)
        .child(gameModel.uid)
        .child(DBConsts.Phases)
        .remove();
  }
}
