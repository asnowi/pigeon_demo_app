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
      ..lineWidth = 2
      ..radius = 10.0
      ..progressColor = Colors.white
      ..backgroundColor = Colors.black.withOpacity(0.7)
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.black.withOpacity(0.6)
      ..userInteractions = true
      ..dismissOnTap = false
      ..maskType = EasyLoadingMaskType.custom
      ..indicatorWidget = Container(
        color: Colors.black,
        width: 42.0,
        height: 42.0,
        child: Lottie.asset(AssetsProvider.lottiePath('loading')),
      );
  }

  static void show([String? text]) {
    EasyLoading.instance.userInteractions = false;
    EasyLoading.show(status: text ?? 'Loading...');
  }

  static void toast(String text) {
    EasyLoading.showToast(text);
  }

  static void dismiss() {
    EasyLoading.instance.userInteractions = true;
    EasyLoading.dismiss();
  }
}