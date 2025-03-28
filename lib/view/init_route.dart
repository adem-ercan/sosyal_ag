import 'package:flutter/material.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/view/auth_route.dart';
import 'package:sosyal_ag/view/splash_screen/splash_screen.dart';

class InitRoute extends StatelessWidget {
  InitRoute({super.key});

  final Init init = locator<Init>();

  @override
  Widget build(BuildContext context) {
  

    return FutureBuilder<void>(
      future: init.start(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done || !init.isFirstInit) {
          
          return const AuthRoute();
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}