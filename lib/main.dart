
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/firebase_options.dart';
import 'package:sosyal_ag/meydan_app.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/utils/theme_provider.dart';


void main() async{ 
  
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);

  setupLocator();


  runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: MeydanApp(),
      ),

  );
  
}

