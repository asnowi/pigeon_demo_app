import 'package:get/get.dart';
import 'package:pigeon_demo_app/pages/welcome/welcome.dart';

class WelcomeController extends GetxController{

  final state = WelcomeState();

  void setHasFirst () {

  }


  @override
  void onReady() {
    this.setHasFirst();
    super.onReady();
  }
}