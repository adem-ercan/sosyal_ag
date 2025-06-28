/* import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/views/init_route.dart';

import 'package:sosyal_ag/views/login_screen/login_screen.dart';
import 'package:sosyal_ag/view_models/user_view_model.dart';

class AuthRoute extends StatelessWidget {
   const AuthRoute({super.key});


  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context, listen: false);

    print("auth route builde oldu");
    return StreamBuilder<bool>(
      stream: userViewModel.authStateChanges(),
      builder: (context, snapshot) {
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          bool isUserLogin = snapshot.data!;
          if (isUserLogin) {

               return InitRoute();
          
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
} */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/blocs/user_bloc/user_bloc.dart';
import 'package:sosyal_ag/blocs/user_bloc/user_state.dart';
import 'package:sosyal_ag/views/init_route.dart';

import 'package:sosyal_ag/views/login_screen/login_screen.dart';
import 'package:sosyal_ag/view_models/user_view_model.dart';
import 'package:sosyal_ag/views/splash_screen/splash_screen.dart';

class AuthRoute extends StatelessWidget {
  const AuthRoute({super.key});

  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(
      context,
      listen: false,
    );

    print("auth route builde oldu");
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is AuthStateChanged) {
          return state.isAuthenticated ? InitRoute() : LoginScreen();
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}
