import 'package:get/get.dart';
import 'package:pigeon_demo_app/common/router/router.dart';
import 'package:pigeon_demo_app/common/store/store.dart';
import 'package:pigeon_demo_app/common/utils/utils.dart';
import 'package:pigeon_demo_app/pages/splash/splash.dart';

class SplashController extends GetxController {

  final state = SplashState();

  @override
  void onInit() {
    LogUtils.GGQ('启动页---> onInit');
    super.onInit();
  }

  @override
  void onReady() {
    LogUtils.GGQ('启动页---> onReady');
    if(ConfigStore.to.isHomeOpen) {
      Get.offAndToNamed(AppRoutes.HOME);
    } else {
      Get.offAndToNamed(AppRoutes.WELCOME);
    }
    super.onReady();
  }

  @override
  void onClose() {
    LogUtils.GGQ('启动页---> onClose');
    super.onClose();
  }

  @override
  void dispose() {
    LogUtils.GGQ('启动页---> dispose');
    super.dispose();
  }
}