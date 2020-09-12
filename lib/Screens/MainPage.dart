import 'package:firstgame/Screens/waitingRoom/WaitingRoom.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FlatButton(
        child: Text("Start The Game"),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => WaitingRoom(
              musicId: "musicUid",
            ),
          ));
        },
      )),
    );
  }
}
