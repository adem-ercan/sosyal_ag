import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_ag/view/login_screen/login_screen.dart';
import 'package:sosyal_ag/view/main_screen/main_screen.dart';

class AuthRoute extends StatelessWidget {
  const AuthRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          User? user = snapshot.data;
          if (user != null) {
           return MainScreen(context: context,);
          }else{
            return const LoginScreen();
          }
          
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Bir hata oluştu'),
            ),
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }
}