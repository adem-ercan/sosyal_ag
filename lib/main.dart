
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/firebase_options.dart';
import 'package:sosyal_ag/meydan_app.dart';
import 'package:sosyal_ag/services/supabase/supabase_auth_service.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/utils/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async{ 
  
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);



  await Supabase.initialize(
  url: 'https://wlmypzctevvzczkefxmq.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndsbXlwemN0ZXZ2emN6a2VmeG1xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYzNDM1NTksImV4cCI6MjA2MTkxOTU1OX0.4G66hVQjWJcCKArZDe6oYVe34ta3doiUAMlVblL8AY8',
  );

  setupLocator();

  SupabaseAuthService supabaseAuthService = SupabaseAuthService();
  AuthResponse? authResponse = await supabaseAuthService.signIn(email: "ademercan.dev@gmail.com", password:  "12345678");

  if (authResponse != null) {
    print("Giriş başarılı");
  } else {
    print("Giriş başarısız");
  }
  
  runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MeydanApp(),
      ),
  );
  
}

