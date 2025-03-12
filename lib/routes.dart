import 'package:go_router/go_router.dart';
import 'package:sosyal_ag/view/intro_screen/intro_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const IntroScreen(),
    ),
  ],
);
