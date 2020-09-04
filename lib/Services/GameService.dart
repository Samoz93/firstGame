import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firstgame/Base/Consts.dart';
import 'package:firstgame/Base/Enums.dart';

class GameService {
  final String gameUid;
  final String player2Uid;

  final _ser = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance;
  User get _me => _ser.currentUser;

  GameService({this.gameUid, this.player2Uid});

  saveDirection(int phase, GDirections dir) async {
    if (_me == null) await _ser.signInAnonymously();
    _db
        .reference()
        .child(DBConsts.Games)
        .child(gameUid)
        .child(DBConsts.Phases)
        .child(_me.uid)
        .update({phase.toString(): dir.index});

    //TODO TEST

    _db
        .reference()
        .child(DBConsts.Games)
        .child(gameUid)
        .child(DBConsts.Phases)
        .child(player2Uid)
        .update({phase.toString(): dir.index});
  }

  Stream get myData {
    return _db
        .reference()
        .child(DBConsts.Games)
        .child(gameUid)
        .child(DBConsts.Phases)
        .child(_me.uid)
        .onValue
        .map((event) => event.snapshot.value);
  }

  Stream get player2Data {
    return _db
        .reference()
        .child(DBConsts.Games)
        .child(gameUid)
        .child(DBConsts.Phases)
        .child(player2Uid)
        .onChildAdded
        .map((event) => event.snapshot.value);
  }

  Future<void> clearRoom() async {
    await _db.reference().child(DBConsts.Games).child(gameUid).remove();
  }
}
