import 'package:firstgame/Screens/waitingRoom/WaitingVm.dart';
import 'package:firstgame/Widget/UpTimer.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class WaitingRoom extends StatelessWidget {
  final String musicId;
  WaitingRoom({Key key, @required this.musicId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ViewModelBuilder<WaitingVm>.reactive(
          viewModelBuilder: () => WaitingVm(musidId: musicId),
          builder: (ctx, model, ch) => model.isBusy
              ? Text("Preparing game's data")
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    UpTimer(),
                    Text("Waiting for p2"),
                  ],
                ),
        ),
      ),
    );
  }
}
