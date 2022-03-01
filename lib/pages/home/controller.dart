import 'package:get/get.dart';
import 'package:pigeon_demo_app/common/store/store.dart';
import 'package:pigeon_demo_app/pages/home/home.dart';

class HomeController extends GetxController {
  final state = HomeState();

  @override
  void onReady() async{
    await ConfigStore.to.saveAlreadyOpen();
    super.onReady();
  }
}