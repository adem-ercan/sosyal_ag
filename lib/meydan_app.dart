import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/utils/theme_provider.dart';
import 'package:sosyal_ag/view_models/login_view_model.dart';
import 'package:sosyal_ag/view_models/main_screen_view_model.dart';
import 'package:sosyal_ag/view_models/post_view_model.dart';
import 'package:sosyal_ag/view_models/profile_page_view_model.dart';
import 'package:sosyal_ag/view_models/signup_view_model.dart';
import 'package:sosyal_ag/view_models/user_view_model.dart';
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
        ChangeNotifierProvider(create: (_) => PostViewModel()),
        ChangeNotifierProvider(create: (_) => ProfilePageViewModel()),

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