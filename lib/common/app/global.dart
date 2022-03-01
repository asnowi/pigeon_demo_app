import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pigeon_demo_app/common/services/services.dart';
import 'package:pigeon_demo_app/common/store/store.dart';

import '../utils/utils.dart';

///全局配置
class Global {
  /// init
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    setSystemUi();
    Loading();
    await Get.putAsync<StorageService>(() => StorageService().init());

    Get.put<ConfigStore>(ConfigStore());
    Get.put<UserStore>(UserStore());

  }


  static void setSystemUi() {
    if (GetPlatform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarDividerColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}