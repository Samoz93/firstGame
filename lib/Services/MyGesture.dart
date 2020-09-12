import 'package:firstgame/Base/Enums.dart';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

class MyGesture extends StatefulWidget {
  final Function(double, GDirections) onUpdate;
  final Function(GDirections) onDone;
  final double threshould;
  final Widget child;
  const MyGesture(
      {Key key, this.onUpdate, this.onDone, this.child, this.threshould = 0.4})
      : super(key: key);

  @override
  _MyGestureState createState() => _MyGestureState();
}

class _MyGestureState extends State<MyGesture> {
  DragUpdateDetails vertical;
  DragUpdateDetails hor;
  DragUpdateDetails pan;
  DragStartDetails panStart;
  Offset ofs;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.withOpacity(0.1),
      child: GestureDetector(
        onPanStart: (d) {
          panStart = d;
        },
        onPanUpdate: (d) {
          pan = d;
          ofs = d.localPosition - panStart.localPosition;
          if (widget.onUpdate != null) widget.onUpdate(opacity, gDir);
        },
        onPanEnd: (d) {
          if (opacity > widget.threshould && widget.onDone != null)
            widget.onDone(gDir);
        },
        child: widget.child,
      ),
    );
  }

  double get dir {
    final crcl = 2 * math.pi;
    if (ofs == null) return crcl;
    final isUpDown = ofs.dy.abs() > ofs.dx.abs();
    if (isUpDown) {
      if (ofs.dy < 0) {
        return crcl * 0.25;
      } else {
        return crcl * -0.25;
      }
    } else {
      if (ofs.dx < 0) {
        return crcl;
      } else {
        return crcl * 0.50;
      }
    }
  }

  String get dirStr {
    if (ofs == null) return "";
    final isUpDown = ofs.dy.abs() > ofs.dx.abs();
    if (isUpDown) {
      if (ofs.dy < 0) {
        return "Up";
      } else {
        return "Down";
      }
    } else {
      if (ofs.dx < 0) {
        return "Left";
      } else {
        return "Right";
      }
    }
  }

  GDirections get gDir {
    return GDirections.values.firstWhere(
        (element) => element.toString().contains(dirStr),
        orElse: () => GDirections.None);
  }

  // MyFlareController ctrl = MyFlareController();
  double get opacity {
    if (ofs == null) return 0;
    final isUpDown = ofs.dy.abs() > ofs.dx.abs();
    final media = MediaQuery.of(Get.context);
    final max = isUpDown ? media.size.height : media.size.width;
    final dir = isUpDown ? ofs.dy.abs() : ofs.dx.abs();
    final op = dir / (max * 0.5);
    final opFinal = math.min<double>(op, 1);
    // ctrl.setAndMoveAnimation(dirStr, opFinal);
    return opFinal;
  }
}
