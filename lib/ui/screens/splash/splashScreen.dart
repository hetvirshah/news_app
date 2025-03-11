import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:news/app/routes.dart';
import 'package:news/ui/screens/homescreen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 8), () {
      Get.toNamed(Routes.homeScreen);
    });

    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/animations/news.lottie.json'),
      ),
    );
  }
}
