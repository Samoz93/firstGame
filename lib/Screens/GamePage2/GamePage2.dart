import 'package:firstgame/Base/AssetsConst.dart';
import 'package:firstgame/Screens/GamePage2/GamePageVm2.dart';
import 'package:firstgame/Screens/MainPage.dart';
import 'package:firstgame/Services/MyGesture.dart';
import 'package:firstgame/Widget/CircularBK.dart';
import 'package:firstgame/Widget/SelectionIcon.dart';
import 'package:firstgame/models/GameModel.dart';
import 'package:firstgame/models/MusicModel.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class GamePage2 extends StatelessWidget {
  final GameModel gameModel;
  final MusicModel musicModel;
  const GamePage2(
      {Key key, @required this.gameModel, @required this.musicModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
      body: SafeArea(
        child: ViewModelBuilder<GamePageVm2>.reactive(
          builder: (ctx, model, ch) {
            if (!model.gameIsready || model.mData == null)
              return Center(
                child: Text("Game isnt ready yet"),
              );

            final totalH = media.size.height -
                media.viewPadding.top -
                media.viewPadding.bottom -
                media.viewInsets.bottom -
                media.viewInsets.top;

            final middleH =
                model.mData.isSelecting ? totalH * 0.5 : totalH * 0.2;
            final upH = model.mData.isSelecting ? totalH * 0.5 : totalH * 0.4;
            final downH = model.mData.isSelecting ? 0.0 : totalH * 0.4;
            return MyGesture(
              onDone: (dir) {
                model.chooseDir(dir);
              },
              onUpdate: (perc, dir) {
                // log("$perc,$dir");
                model.animate(perc, dir);
              },
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      AnimatedContainer(
                        duration: model.animDuration,
                        color: Colors.red,
                        height: upH,
                        child: Stack(
                          children: <Widget>[
                            FlareActor(
                              AssetsConst.faceFlare2,
                              // color: model.isShowingScore ? Colors.blue : null,
                              fit: BoxFit.fitHeight,
                              alignment: Alignment.bottomCenter,
                              controller: model.ctr,

                              callback: (anim) {},
                            ),
                            //TODO based on isMeHead choose the flare asset
                            Center(
                              child: Text("this is head = ${model.isMeHead}"),
                            )
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: model.animDuration,
                        color: Colors.blue,
                        height: middleH,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: model.gameOver
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      model.isMeHead ? "Game Over" : "You Won",
                                    ),
                                    CircularBK(
                                      child: FlatButton(
                                        child: Text("New Game"),
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => MainPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : Flex(
                                  direction: Axis.vertical,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    // selection
                                    model.mData.isSelecting
                                        ? Flexible(
                                            flex: 5, child: _getPos(model))
                                        : SizedBox(),
                                    Flexible(
                                      flex: 10,
                                      child: Flex(
                                        direction: Axis.horizontal,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          model.mData.isSelecting
                                              ? SizedBox()
                                              : Flexible(
                                                  flex: 2,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: middleH * 0.3),
                                                    child: CircularBK(
                                                      child: SelectionIcon(
                                                          dir: model.lstGDirP2),
                                                    ),
                                                  ),
                                                ),
                                          Flexible(
                                            flex: 10,
                                            child: CircularBK(
                                              child: Text(model.mData.counter
                                                  .toString()),
                                            ),
                                          ),
                                          model.mData.isSelecting
                                              ? SizedBox()
                                              : Flexible(
                                                  flex: 2,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: middleH * 0.3),
                                                    child: CircularBK(
                                                      child: SelectionIcon(
                                                          dir: model
                                                              .currentRoundChoicesByPos),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: model.animDuration,
                        color: Colors.yellow,
                        height: downH,
                        width: double.infinity,
                        child: FlareActor(
                          AssetsConst.faceFlare2,
                          // color: model.isShowingScore ? Colors.blue : null,
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.bottomCenter,
                          controller: model.p2ctr,
                          callback: (anim) {},
                        ),
                      ),
                    ],
                  ),
                  Center(child: Text(model.round.toString()))
                ],
              ),
            );
          },
          viewModelBuilder: () =>
              GamePageVm2(gameModel: gameModel, musicModel: musicModel),
          onModelReady: (v) => v.start(),
        ),
      ),
    );
  }

  Widget _getPos(GamePageVm2 vm) {
    final List<Widget> lst = [];
    final wd = MediaQuery.of(Get.context).size.width / (vm.mData.nodeCount + 5);
    for (var i = 0; i < vm.mData.nodeCount; i++) {
      lst.add(
        CircularBK(
          child: Container(
            width: wd,
            height: wd,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectionIcon(
                dir: vm.getChoiceByIndex(i),
              ),
            ),
          ),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        vm.mData.isSelecting
            ? Text("Swipe up/down/left/right to choose your Next Moves")
            : SizedBox(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[...lst],
        ),
      ],
    );
  }
}
