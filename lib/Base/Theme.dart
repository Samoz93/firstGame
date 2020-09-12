import 'package:flutter/cupertino.dart';

class AppColors {
  static const Color whiteColor = Color(0xffFEFEFE);
  static const Color goldenColor = Color(0xffE4A563);
}

class AppConstTheme {
  static const BoxShadow mainShadow = BoxShadow(
      blurRadius: 4, color: AppColors.goldenColor, offset: Offset(1, 3));
}
