import 'dart:async';

import 'package:firstgame/Services/MusicService.dart';
import 'package:firstgame/models/MusicModel.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  TestScreen({Key key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final ser = MusicService();
  @override
  void initState() {
    super.initState();
    _setData();
  }

  MusicData d;
  String isFinished = "No";
  _setData() async {
    final data = (await ser.musicList)[0];
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        d = data.getData(timer.tick);
      });

      if (timer.tick > data.totalLength + 1) {
        setState(() {
          isFinished = "Yes";
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text(d.toString()), Text(isFinished)],
        ),
      ),
    );
  }
}
