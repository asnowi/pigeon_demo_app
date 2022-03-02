import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:pigeon_demo_app/common/config/config.dart';
import 'package:pigeon_demo_app/common/services/services.dart';

class ConfigStore extends GetxController {
  static ConfigStore get to => Get.find();

  bool isHomeOpen = false;
  PackageInfo? _platform;
  String get version => _platform?.version ?? '-';
  bool get isRelease => const bool.fromEnvironment("dart.vm.product");
  Locale locale = Locale('en', 'US');
  List<Locale> languages = [
    Locale('en', 'US'),
    Locale('zh', 'CN'),
  ];

  @override
  void onInit() {
    super.onInit();
    isHomeOpen = StorageService.to.getBool(SaveInfoKey.FIRST_OPEN);
  }

  Future<void> getPlatform() async {
    _platform = await PackageInfo.fromPlatform();
  }

  // 标记用户已打开APP
  Future<bool> saveAlreadyOpen() {
    return StorageService.to.setBool(SaveInfoKey.FIRST_OPEN, false);
  }

  void onInitLocale() {
    var langCode = StorageService.to.getString(SaveInfoKey.LANGUAGE_CODE);
    if (langCode.isEmpty) return;
    var index = languages.indexWhere((element) {
      return element.languageCode == langCode;
    });
    if (index < 0) return;
    locale = languages[index];
  }

  void onLocaleUpdate(Locale value) {
    locale = value;
    Get.updateLocale(value);
    StorageService.to.setString(SaveInfoKey.LANGUAGE_CODE, value.languageCode);
  }
}
