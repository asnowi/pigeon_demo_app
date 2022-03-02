import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pigeon_demo_app/common/langs/langs.dart';
import 'package:pigeon_demo_app/common/router/router.dart';
import 'package:pigeon_demo_app/common/store/store.dart';
import 'package:pigeon_demo_app/common/style/style.dart';
import 'package:pigeon_demo_app/pages/unknown/unknown.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'common/app/app.dart';
import 'common/utils/utils.dart';

Future<void> main() async {
  await Global.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: () => RefreshConfiguration(
        headerBuilder: () => const WaterDropHeader(),
        footerBuilder:  () => const ClassicFooter(),
        headerTriggerDistance: 80.0,
        springDescription: const SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
        maxOverScrollExtent :100,
        maxUnderScrollExtent:100,
        enableScrollWhenRefreshCompleted: true,
        enableLoadingWhenFailed : true,
        hideFooterWhenNotFull: false,
        enableBallisticLoad: true,
        child: GetMaterialApp(
          title: 'Pigeon Demo App',
          theme: AppTheme.light,
          debugShowCheckedModeBanner: false,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          unknownRoute: AppPages.unknownPage(),
          builder: EasyLoading.init(),
          translations: TranslationService(),
          navigatorObservers: [AppPages.observer],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: ConfigStore.to.languages,
          locale: ConfigStore.to.locale,
          fallbackLocale: TranslationService.fallbackLocale,
          // 日志
          enableLog: true,
          logWriterCallback: LogUtils.write,
        ),
      ),
    );
  }
}
