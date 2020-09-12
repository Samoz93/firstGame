import 'dart:async';
import 'dart:developer';

import 'package:firstgame/Screens/GamePage2/GamePage2.dart';
import 'package:firstgame/Services/MusicService.dart';
import 'package:firstgame/Services/WaitingService.dart';
import 'package:firstgame/models/GameModel.dart';
import 'package:firstgame/models/MusicModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class WaitingVm extends BaseViewModel {
  MusicModel _musicModel;
  MusicModel get musicModel => _musicModel;
  final _waitingSer = WaitingService();
  final _musicSer = Get.find<MusicService>();

  StreamSubscription _sub;
  final String musidId;
  WaitingVm({@required this.musidId}) {
    initData();
  }
  initData() async {
    setBusy(true);
    _musicModel = await _musicSer.getMusic(musidId);
    _gameStream = await _waitingSer.searchForGame2();

    _startListening();
    setBusy(false);
  }

  Stream<GameModel> _gameStream;

  _startListening() {
    _sub = _gameStream.listen((event) {
      if (event.isFull) {
        Get.off(
          GamePage2(
            gameModel: event,
            musicModel: musicModel,
          ),
        );
      } else {
        log(event.toString());
      }
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    _waitingSer.cancelSub();
    super.dispose();
  }
}
