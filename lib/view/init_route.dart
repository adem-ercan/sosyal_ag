import 'package:flutter/material.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/view/auth_route.dart';
import 'package:sosyal_ag/view/splash_screen/splash_screen.dart';

class InitRoute extends StatelessWidget {
  const InitRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: Init.start(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const AuthRoute();
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}