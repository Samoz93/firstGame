import 'dart:developer';

import 'package:firstgame/Base/Consts.dart';
import 'package:firstgame/Base/Enums.dart';
import 'package:firstgame/Screens/GamerVM.dart';
import 'package:firstgame/Services/MyGesture.dart';
import 'package:firstgame/Timer.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../Widget/Ok.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final media = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: ViewModelBuilder<GamerPageVM>.reactive(
        viewModelBuilder: () => GamerPageVM(),
        builder: (ctx, model, ch) => MyGesture(
          onDone: (dir) {
            if (model.activePhase.isLocked ||
                model.isShowingScore ||
                !model.started) return;

            model.ctr.setAndMoveAnimation("cancel", 0);
            model.chooseSide(dir);
          },
          onUpdate: (perc, dir) {
            if (model.activePhase.isLocked ||
                model.isShowingScore ||
                !model.started) return;
            model.ctr.setAndMoveAnimation(gDirToString(dir), perc);
          },
          child: Stack(
            children: <Widget>[
              Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Stack(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            model.startTimer();
                          },
                          child: FlareActor(
                            "assets/g2.flr",
                            color: model.isShowingScore ? Colors.blue : null,
                            fit: BoxFit.fitHeight,
                            alignment: Alignment.bottomCenter,
                            controller: model.ctr,
                            callback: (anim) {
                              log(anim);
                            },
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Text(model.activePhase.phase.toString()),
                            dirIcon(model.activePhase.choosedSide),
                            FlatButton(
                              child: Text("Stop"),
                              onPressed: model.stopAll,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      // color: Colors.red,
                      width: double.infinity,
                      height: double.infinity,
                      child: StreamBuilder(
                        stream: model.player2Stream,
                        initialData: 4,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return OkWidget(
                            icon: _iconData(GDirections.values.firstWhere(
                                (element) => element.index == snapshot.data)),
                            show: model.isShowingScore,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: OkWidget(
                  icon: _iconData(model.activePhase.choosedSide),
                  show: model.activePhase.isLocked && !model.isShowingScore,
                ),
              ),
              model.started
                  ? Container(
                      child: TimerWidget(
                      seconds: model.currentSecond,
                      showTimer: model.showTimer,
                    ))
                  : SizedBox()
            ],
          ),
        ),
      )),
    );
  }

  Widget dirIcon(GDirections dir) {
    return Icon(_iconData(dir));
  }

  IconData _iconData(GDirections dir) {
    IconData str;
    switch (dir) {
      case GDirections.Down:
        str = Icons.keyboard_arrow_down;
        break;
      case GDirections.Up:
        str = Icons.keyboard_arrow_up;
        break;
      case GDirections.Left:
        str = Icons.chevron_left;
        break;
      case GDirections.Right:
        str = Icons.chevron_right;
        break;
      default:
        str = Icons.query_builder;
    }
    return str;
  }
}
