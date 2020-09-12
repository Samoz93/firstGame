import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firstgame/Base/Consts.dart';
import 'package:firstgame/models/GameModel.dart';
import 'package:uuid/uuid.dart';
import 'package:rxdart/rxdart.dart';

class WaitingService {
  final _db = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;
  BehaviorSubject<bool> _gameStarted = BehaviorSubject.seeded(false);
  StreamSubscription _sub;
  restartTheGame() async {
    await clearRoom(_roomUid);
    _gameStarted.add(false);
  }

  Stream<GameModel> get gameStream {
    return _search();
  }

  clearRoom(String roomUid) {
    _db.reference().child(DBConsts.Games).child(roomUid).remove();
  }

  bool _gameFound = false;
  String _roomUid;
  _search() {
    return _db
        .reference()
        .child(DBConsts.WaitingRoom)
        .onValue
        .switchMap((event) {
      if (_gameFound) return _getroomStream(_roomUid);
      if (event.snapshot.value == null) {
        _addMySelfToWaiting();
      } else {
        final Map<dynamic, dynamic> map = Map.from(event.snapshot.value);
        final otherPlayres = map.keys.where((element) => element != _user.uid);
        if (otherPlayres.length < 1) {
          return Stream.value(null);
        }
        final firstData = otherPlayres.first;
        final roomUid = map[firstData];
        _roomUid = roomUid;
        _gameFound = true;
        _joinRoom(roomUid, firstData, false);
        _db.reference().child(DBConsts.WaitingRoom).child(firstData).remove();
        return _getroomStream(roomUid);
      }
    });
  }

  Future<Stream<GameModel>> searchForGame2() async {
    final availableGames = (await _db
            .reference()
            .child(DBConsts.Games)
            .orderByChild("isFull")
            .equalTo(false)
            .once())
        .value;

    if (availableGames == null) {
      return _createMyGame();
    } else {
      final map = convertToMap(availableGames);
      final firstGame = GameModel.fromJson(convertToMap(map.values.first));
      return _joinGame(firstGame);
    }
  }

  Stream<GameModel> _joinGame(GameModel model) {
    model.isFull = true;
    model.player2 = _user.uid;

    _db
        .reference()
        .child(DBConsts.Games)
        .child(model.uid)
        .update(model.toJson());

    return _getGameStream(model.uid);
  }
  // _deleteFromWaiting(String p2Uid) async {
  //   await _db
  //       .reference()
  //       .child(DBConsts.WaitingRoom)
  //       .runTransaction((mutableData) async {
  //     mutableData.value[_user.uid] = null;
  //     mutableData.value[p2Uid] = null;
  //     return mutableData;
  //   });
  // }

  _joinRoom(String roomUid, String p2Uid, bool isMeOwner) async {
    final _gModel = GameModel(
      isFull: true,
      uid: roomUid,
      isWaiting: false,
      owner: isMeOwner ? _user.uid : p2Uid,
      player2: isMeOwner ? p2Uid : _user.uid,
      startDate: DateTime.now().millisecondsSinceEpoch,
    );
    await _db
        .reference()
        .child(DBConsts.Games)
        .child(roomUid)
        .update(_gModel.toJson());
  }

  Stream<GameModel> _getroomStream(String roomUid) {
    return _db.reference().child(DBConsts.Games).child(roomUid).onValue.map(
        (event) => event.snapshot.value == null
            ? null
            : GameModel.fromJson(convertToMap(event.snapshot.value))
          ..isWaiting = false);
  }

  _addMySelfToWaiting() {
    final roomUid = Uuid().v1();
    _db.reference().child(DBConsts.WaitingRoom).update({_user.uid: roomUid});
  }

  // _testAnotherUserEntered() {
  //   final uid = Uuid().v1();

  //   Future.delayed(Duration(seconds: waitingDuration))
  //       .then((value) => _testUserEntered(uid));
  // }

  // _testUserEntered(String uid) {
  //   _db.reference().child(DBConsts.WaitingRoom).update({uid: "ssss"});
  // }

  final waitingDuration = 5;
  User get _user {
    return _auth.currentUser;
  }

  cancelSub() {
    _sub.cancel();
  }

  Stream<GameModel> _createMyGame() {
    final roomUid = Uuid().v1();
    _db.reference().child(DBConsts.Games).child(roomUid).update(
          GameModel(
                  isFull: false,
                  isWaiting: true,
                  owner: _user.uid,
                  startDate: DateTime.now().millisecondsSinceEpoch,
                  uid: roomUid)
              .toJson(),
        );
    return _getGameStream(roomUid);
  }

  Stream<GameModel> _getGameStream(String roomUid) {
    return _db
        .reference()
        .child(DBConsts.Games)
        .child(roomUid)
        .onValue
        .map((event) => GameModel.fromJson(convertToMap(event.snapshot.value)));
  }
}
