import 'package:go_router/go_router.dart';
import 'package:sosyal_ag/view/init_route.dart';
import 'package:sosyal_ag/view/login_screen/login_screen.dart';

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
  ],
);
