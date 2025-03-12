import 'package:go_router/go_router.dart';
import 'package:sosyal_ag/view/splash_screen/splash_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),

   /*  GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ), */
  ],
);
