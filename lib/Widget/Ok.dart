import 'dart:async';

import 'package:flutter/material.dart';

class OkWidget extends StatefulWidget {
  bool show;
  final IconData icon;
  OkWidget({Key key, this.show = false, this.icon = Icons.query_builder})
      : super(key: key);

  @override
  _OkWidgetState createState() => _OkWidgetState();
}

class _OkWidgetState extends State<OkWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.show) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          widget.show = false;
          timer.cancel();
        });
      });
    }
    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: widget.show ? 1 : 0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: widget.show ? MediaQuery.of(context).size.width * 0.5 : 0,
        height: widget.show ? MediaQuery.of(context).size.height * 0.5 : 0,
        child: LayoutBuilder(
          builder: (context, constraints) => Icon(
            widget.icon,
            size: constraints.biggest.width,
            color: Colors.greenAccent,
          ),
        ),
      ),
    );
  }
}
