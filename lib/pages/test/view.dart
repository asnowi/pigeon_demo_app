import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pigeon_demo_app/common/utils/utils.dart';

import 'test.dart';

class TestView extends GetView<TestController>{

  const TestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(onPressed: (){
            Loading.show();
          }, child: const Text('loading show')),
          TextButton(onPressed: (){
            Loading.toast('toast');
          }, child: const Text('toast show'))
        ],
      )
    );
  }

}