import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/utils/theme_provider.dart';


class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
     
      body: Center(
        child: ElevatedButton(onPressed: 
        (){
          themeProvider.toggleTheme(); 
        }, child: Text('Theme')),
      ),
    );
  }
}