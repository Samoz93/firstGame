import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class TimerWidget extends StatefulWidget {
  final int seconds;
  final bool showTimer;
  final int starSize;
  final int endSize;
  const TimerWidget(
      {Key key,
      this.seconds,
      this.showTimer = true,
      this.endSize = 200,
      this.starSize = 15})
      : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _ctrl;
  SequenceAnimation sequenceAnimation;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(vsync: this, duration: Duration(seconds: 1));

    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: new ColorTween(begin: Colors.red, end: Colors.yellow),
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 800),
            tag: "color")
        .addAnimatable(
          animatable: Tween<double>(begin: 200, end: 15),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 800),
          tag: "size",
          curve: Curves.easeOut,
        )
        .animate(_ctrl);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) => Center(
        child: Center(
          child: Container(
            width: widget.showTimer ? sequenceAnimation['size'].value : 0,
            height: widget.showTimer ? sequenceAnimation['size'].value : 0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.seconds.toString(),
                style: TextStyle(
                  fontSize: sequenceAnimation['size'].value,
                  color: widget.seconds > 2
                      ? Colors.green
                      : sequenceAnimation['color'].value,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
