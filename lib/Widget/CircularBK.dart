import 'package:firstgame/Base/Theme.dart';
import 'package:flutter/material.dart';

class CircularBK extends StatelessWidget {
  final Widget child;
  const CircularBK({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.whiteColor,
          boxShadow: [AppConstTheme.mainShadow]),
      child: Center(child: child),
    );
  }
}
