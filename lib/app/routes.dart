import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news/ui/screens/homescreen.dart';
import 'package:news/ui/screens/onboardingScreen.dart';
import 'package:news/ui/screens/splash/splashScreen.dart';

class Routes {
  static const loginScreen = '/login';
  static const onboardingScreen = '/onboarding';
  static const splashScreen = '/splash';
  static const homeScreen = '/home';

  static final routes = <GetPage<Widget>>[
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: onboardingScreen, page: () => const Onboarding()),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
  ];
}

extension RoutesExtension on String {
  void push() {
    Get.toNamed<void>(this);
  }

  void pushReplace() {
    Get.offNamed<void>(this);
  }
}
