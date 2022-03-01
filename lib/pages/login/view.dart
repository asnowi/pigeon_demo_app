import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pigeon_demo_app/common/widget/dialog/permission_dialog.dart';

import 'login.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: const Icon(Icons.ac_unit),
                  onPressed: _onClick
              ),
              IconButton(
                  icon: const Icon(Icons.label),
                  onPressed: _onLoading
              ),
              IconButton(
                  icon: const Icon(Icons.mode),
                  onPressed: () => _onPermission(context)
              ),
            ],
          )
        ),
      );
  }

   void _onClick() {

  }

  void _onLoading() {
  }

  void _onPermission(BuildContext context) {
    PermissionDialog.show(context);
  }

}