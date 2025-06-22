import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/utils/theme_provider.dart';
import 'package:sosyal_ag/views/main_screen/main_screen.dart';
import 'package:sosyal_ag/views/splash_screen/splash_screen.dart';

class InitRoute extends StatelessWidget {
  InitRoute({super.key});

  final Init init = locator<Init>();

  @override
  Widget build(BuildContext context) {
    print("init route build oldu");

    return FutureBuilder<void>(
      future: init.start(context),
      builder: (context, snapshot) {
        if (snapshot.hasData || !init.isFirstInit) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingWidget();
          }
          return MainScreen(context: context);
        } else {
          
          return SplashScreen();
        }
      },
    );
  }
}



class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar:  AppBar(
                actions: [
                  
                ],
                title:
                    themeProvider.themeMode != ThemeMode.dark
                        ? Image.asset(
                          "assets/logo/meydan_dark.png",
                          height: 30,
                          //width: diaQuery.of(context).size.width * .6,
                        )
                        : Image.asset(
                          "assets/logo/meydan_light.png",
                          height: 30,
                          //width: MediaQuery.of(context).size.width * .6,
                        ),

                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),

              body: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
    );
  }
}
