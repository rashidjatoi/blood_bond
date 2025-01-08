import '/bindings/controller_binder.dart';
import '/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/splash/screen/splash_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: EAppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialBinding: ControllerBinder(),
      home: const SplashView(),
      getPages: [
        GetPage(
          name: '/splash',
          page: () => const SplashView(),
        ),
      ],
    );
  }
}
