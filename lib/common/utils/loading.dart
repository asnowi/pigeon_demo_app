import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:pigeon_demo_app/common/utils/utils.dart';

class Loading {
  Loading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 35.0
      ..lineWidth = 1.0
      ..radius = 10.0
      ..progressColor = Colors.white
      ..backgroundColor = Colors.white
      ..textColor = Colors.black.withOpacity(0.7)
      ..maskColor = Colors.black.withOpacity(0.6)
      ..indicatorColor = Colors.black
      ..userInteractions = true
      ..dismissOnTap = false
      ..maskType = EasyLoadingMaskType.custom
      ..indicatorWidget = Container(
        color: Colors.white,
        width: 32.0,
        height: 48.0,
        child: Lottie.asset(AssetsProvider.lottiePath('loading')),
      );
  }

  static void show([String? text]) {
    EasyLoading.instance.userInteractions = false;
    EasyLoading.show(status: text ?? 'loading...');
  }

  static void dismiss() {
    EasyLoading.instance.userInteractions = true;
    EasyLoading.dismiss();
  }
}