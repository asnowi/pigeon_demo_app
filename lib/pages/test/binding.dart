import 'package:get/get.dart';

import 'test.dart';

class TestBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<TestController>(() => TestController());
  }

}