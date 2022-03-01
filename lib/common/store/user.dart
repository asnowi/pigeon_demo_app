import 'dart:convert';


import 'package:get/get.dart';
import 'package:pigeon_demo_app/common/config/config.dart';
import 'package:pigeon_demo_app/common/entity/user.dart';

import '../services/services.dart';

class UserStore extends GetxController {
  static UserStore get to => Get.find();

  // 是否登录
  final _isLogin = false.obs;
  // 令牌 token
  String token = '';
  // 用户 user info
  final _userInfo = UserInfo().obs;

  bool get isLogin => _isLogin.value;
  UserInfo get userInfo => _userInfo.value;
  bool get hasToken => token.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    token = StorageService.to.getString(SaveInfoKey.TOKEN);
    var profileOffline = StorageService.to.getString(SaveInfoKey.USER_INFO);
    if (profileOffline.isNotEmpty) {
      _userInfo(UserInfo.fromJson(jsonDecode(profileOffline)));
    }
  }

  // 保存 token
  Future<void> saveToken(String token) async {
    await StorageService.to.setString(SaveInfoKey.TOKEN, token);
    this.token = token;
  }


  // 保存 user info
  Future<bool> saveUserInfo(UserInfo profile) async {
    _isLogin.value = await StorageService.to.setString(SaveInfoKey.USER_INFO, jsonEncode(profile));
    return isLogin;
  }

  // 删除 user info
  Future<bool> removeUserInfo() async {
    _isLogin.value = await StorageService.to.remove(SaveInfoKey.TOKEN);
    return isLogin;
  }
}
