import 'package:go_router/go_router.dart';
import 'package:sosyal_ag/view/auth_route.dart';
import 'package:sosyal_ag/view/init_route.dart';
import 'package:sosyal_ag/view/login_screen/login_screen.dart';
import 'package:sosyal_ag/view/sign_up_screen/sign_up_screen.dart';

final router = GoRouter(
  routes: [

    GoRoute(
      path: '/',
      builder: (context, state) => const InitRoute(),
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),

    GoRoute(
      path: '/authRoute',
      builder: (context, state) => const AuthRoute(),
    ),
    
  ],
);
