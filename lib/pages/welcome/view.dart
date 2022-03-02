import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'welcome.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('测试'),
      ),
    );
  }

}