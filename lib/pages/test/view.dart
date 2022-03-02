import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'test.dart';

class TestView extends GetView<TestController>{

  const TestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('测试页')),
    );
  }

}