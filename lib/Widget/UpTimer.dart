import 'dart:async';

import 'package:flutter/material.dart';

class UpTimer extends StatefulWidget {
  UpTimer({Key key}) : super(key: key);

  @override
  _UpTimerState createState() => _UpTimerState();
}

class _UpTimerState extends State<UpTimer> {
  Timer t;
  int seconds = 0;
  @override
  void initState() {
    super.initState();
    t = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
  }

  @override
  void dispose() {
    t.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(seconds.toString()),
    );
  }
}
