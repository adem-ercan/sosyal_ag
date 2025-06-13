import 'package:go_router/go_router.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/views/auth_route.dart';
import 'package:sosyal_ag/views/followers_screen/followers_screen.dart';
import 'package:sosyal_ag/views/following_screen/following_screen.dart';
import 'package:sosyal_ag/views/init_route.dart';
import 'package:sosyal_ag/views/login_screen/login_screen.dart';
import 'package:sosyal_ag/views/main_screen/main_screen.dart';
import 'package:sosyal_ag/views/other_screens/notification_screen.dart';
import 'package:sosyal_ag/views/other_screens/other_user_profile_screen.dart';
import 'package:sosyal_ag/views/post_screen/post_screen.dart';
import 'package:sosyal_ag/views/profile_edit_screen/profile_edit_screen.dart';
import 'package:sosyal_ag/views/settings_screen/setting_screen.dart';
import 'package:sosyal_ag/views/sign_up_screen/sign_up_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => InitRoute()),

    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),

    GoRoute(path: '/profileEdit', builder: (context, state) =>  ProfileEditScreen()),

    GoRoute(
      path: '/mainScreen',
      builder: (context, state) => MainScreen(context: context),
    ),

    GoRoute(path: '/authRoute', builder: (context, state) =>  AuthRoute()),
    GoRoute(
      path: '/otherUserProfile',
      builder: (context, state) {
        final UserModel user = state.extra as UserModel;
        return OtherUserProfileScreen(user: user);
      },
    ),

    GoRoute(
      path: '/postScreen',
      builder: (context, state) {
        final Map<String, dynamic> mapData =
            state.extra as Map<String, dynamic>;
        return PostScreen(mapData: mapData);
      },
    ),

    GoRoute(
      path: '/notificationScreen',
      builder: (context, state) => const NotificationScreen(),
    ),

    GoRoute(
      path: '/settingsScreen',
      builder: (context, state) => const SettingsScreen(),
    ),

    GoRoute(
      path: '/followersScreen',
      builder: (context, state) => FollowersScreen(),
      
    ),

    GoRoute(
      path: '/followingScreen',
      builder: (context, state) => FollowingScreen(),
      
    ),
  ],
);
