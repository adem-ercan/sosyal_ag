import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/view/login_screen/login_screen.dart';
import 'package:sosyal_ag/view/main_screen/main_screen.dart';
import 'package:sosyal_ag/view_model/user_view_model.dart';

class AuthRoute extends StatelessWidget {
  const AuthRoute({super.key});

  @override
  Widget build(BuildContext context) {

    UserViewModel userViewModel = Provider.of<UserViewModel>(context);


    return StreamBuilder<bool>(
      stream: userViewModel.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          bool isUserLogin = snapshot.data!;
          if (isUserLogin) {
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