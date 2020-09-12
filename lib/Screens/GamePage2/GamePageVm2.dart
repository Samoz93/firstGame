import 'dart:async';
import 'dart:developer';

import 'package:firstgame/Base/Consts.dart';
import 'package:firstgame/Base/Enums.dart';
import 'package:firstgame/Services/FlareCtrl.dart';
import 'package:firstgame/Services/GameService.dart';
import 'package:firstgame/models/GameModel.dart';
import 'package:firstgame/models/MusicModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class GamePageVm2 extends BaseViewModel {
  MusicModel musicModel;
  GameService _gameSer;

  final ctr = MyFlareController();
  final p2ctr = MyFlareController();
  bool gameIsready = true;
  final GameModel gameModel;

  String p2;
  String winner;
  GamePageVm2({@required this.musicModel, @required this.gameModel}) {
    _gameSer = GameService(gameModel: gameModel);
  }
  Timer mainTimer;

  final animDuration = Duration(milliseconds: 300);
  //Round
  int _round = 0;
  int get round => _round;
  set round(int val) {
    _round = val;
    notifyListeners();
  }

  //Music Data
  MusicData _mData;
  MusicData get mData => _mData;
  set mData(MusicData d) {
    _mData = d;
    notifyListeners();
  }

  bool get isMeHead {
    return gameModel.amITheOwner(_gameSer.me.uid) && (round % 2 == 0);
  }

  //Music Data
  int _correctedPos;
  int get correctedPos => _correctedPos;
  set correctedPos(int d) {
    _correctedPos = d;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _lstRound = -1;
  start() async {
    mainTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      final tick = timer.tick;
      correctedPos = tick % musicModel.totalLength;
      round = (tick / musicModel.totalLength).floor();
      if (round > _lstRound) {
        savedData.add(List<int>());
        log("curent$round lst$_lstRound");
      }
      _lstRound = round;
      _mData = musicModel.getData(correctedPos);
      _setMyAnimation();
      listenToP2Moves();
      checkForscore();
    });
  }

  _setMyAnimation() {
    final showIndex = _mData.indexOfBeat(correctedPos);
    if (showIndex > -1) {
      ctr.cancelAnimation();
      final animName = gDirToString(currentRoundChoices[showIndex]);
      ctr.anim = animName;
    }
  }

  List<List<int>> savedData = List<List<int>>();
  chooseDir(GDirections dir) {
    if (!_mData.isSelecting) return;
    try {
      // while (savedData.length < round + 1) {
      //   savedData.add(List<int>());
      // }
      var currentRoundData = currentRoundDataa;

      if (currentRoundData.length >= mData.nodeCount) return;
      savedData[round] = currentRoundData..add(dir.index);
      log(savedData.toString());
      ctr.cancelAnimation();
      _saveToDatabaseAsString(currentRoundData.length - 1, dir);
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  _saveToDatabaseAsString(int indexOfBeat, GDirections dir) {
    final beatPos = _mData.showPos[indexOfBeat];
    final str = phaseDataToString(round, beatPos);
    _gameSer.saveDirection(str, dir);
  }

  List<int> get currentRoundDataa {
    return savedData[round];
  }

  List<GDirections> get currentRoundChoices {
    List<GDirections> emptyList = _getEmptyList;
    if (savedData.length < round + 1) {
      return emptyList;
    } else {
      emptyList = savedData[round].map((e) => gDirByIndex(e)).toList();
      while (emptyList.length < _mData.nodeCount) {
        emptyList.add(GDirections.None);
      }
    }
    return emptyList;
  }

  GDirections _lstGDir;
  GDirections get currentRoundChoicesByPos {
    final showIndex = _mData.indexOfBeat(correctedPos);
    if (_mData.isSelecting) _lstGDir = null;
    if (showIndex < 0) return _lstGDir;
    _lstGDir = currentRoundChoices[showIndex];
    return _lstGDir;
  }

  GDirections getChoiceByIndex(int index) {
    try {
      final lst = currentRoundChoices;
      return lst[index];
    } catch (e) {
      return GDirections.None;
    }
  }

  List<GDirections> get _getEmptyList {
    return List.filled(_mData.nodeCount, GDirections.None);
  }

  void animate(double perc, GDirections dir) {
    if (!_mData.isSelecting) return;
    if (currentRoundDataa.length >= mData.nodeCount) return;

    ctr.setAndMoveAnimation(gDirToString(dir), perc);
  }

  _setP2Animation(String anime) {
    p2ctr.cancelAnimation();
    p2ctr.anim = anime;
  }

  dynamic _p2Data;
  listenToP2Moves() async {
    if (_mData.isSelecting) {
      _p2Data = null;
      lstGDirP2 = null;
      return;
    }
    if (_p2Data == null) _p2Data = await _gameSer.player2DataFuture;

    if (beatIndex > -1) {
      final str = phaseDataToString(round, beatPos);
      final dirIndex = _p2Data[str];
      lstGDirP2 = gDirByIndex(dirIndex);
      final anim = gDirStringByIndex(dirIndex);
      _setP2Animation(anim);
    }
  }

  GDirections lstGDirP2;

  int get beatPos {
    final indexOfBeat = _mData.indexOfBeat(correctedPos);
    return _mData.showPos[indexOfBeat];
  }

  int get beatIndex {
    return _mData.showPos.indexOf(correctedPos);
  }

  bool gameOver = false;
  bool get isMeLost {
    return isMeHead;
  }

  _stopGame() {
    mainTimer.cancel();
  }

  checkForscore() {
    if (_mData.isSelecting) return;
    if (lstGDirP2 != null &&
        currentRoundChoicesByPos != null &&
        currentRoundChoicesByPos.index != GDirections.None.index &&
        currentRoundChoicesByPos.index == lstGDirP2.index) {
      gameOver = true;
      // Get.dialog(
      //   Dialog(
      //     child: Padding(
      //       padding: const EdgeInsets.all(20.0),
      //       child: Center(child: Text(isMeHead ? "You Lost" : "You Won")),
      //     ),
      //   ),
      //   barrierDismissible: false,
      // );
      ctr.anim = isMeHead ? "Game Over" : "Chomp";
      _stopGame();
      notifyListeners();
    }
  }
}
