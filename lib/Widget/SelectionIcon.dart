import 'package:firstgame/Base/AssetsConst.dart';
import 'package:firstgame/Base/Enums.dart';
import 'package:flutter/material.dart';

class SelectionIcon extends StatelessWidget {
  final GDirections dir;
  const SelectionIcon({Key key, this.dir = GDirections.None}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: _getRotation,
      child: Image.asset(
        GDirections.None == dir
            ? AssetsConst.swipeGesture
            : AssetsConst.arrowUp,
        fit: BoxFit.fill,
      ),
    );
  }

  int get _getRotation {
    switch (dir) {
      case GDirections.Right:
        return 1;
      case GDirections.Down:
        return 2;
      case GDirections.Left:
        return 3;

      default:
        return 0;
        break;
    }
  }
}
