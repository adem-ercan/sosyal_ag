import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/utils/theme_provider.dart';
import 'package:sosyal_ag/view_model/login_view_model.dart';
import 'package:sosyal_ag/view_model/main_screen_view_model.dart';
import 'package:sosyal_ag/view_model/signup_view_model.dart';
import 'package:sosyal_ag/view_model/user_view_model.dart';
import 'utils/routes.dart';

class MeydanApp extends StatelessWidget {
  const MeydanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => MainScreenViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignupViewModel()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            title: 'Meydan App',
            theme: themeProvider.themeDataLight,
            darkTheme: themeProvider.themeDataDark,
            themeMode: themeProvider.themeMode,
          );
        },
      ),
    );
  }
}