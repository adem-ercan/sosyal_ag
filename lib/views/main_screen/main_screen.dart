import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/utils/theme_provider.dart';
import 'package:sosyal_ag/views/main_screen/drawer/drawer.dart';
import 'package:sosyal_ag/views/main_screen/main_page/main_page.dart';
import 'package:sosyal_ag/views/main_screen/messages_page/messages_page.dart';
import 'package:sosyal_ag/views/main_screen/meydan_page/meydan_page.dart';
import 'package:sosyal_ag/views/main_screen/profile_page/profile_page.dart';
import 'package:sosyal_ag/views/main_screen/search_page/search_page.dart';
import 'package:sosyal_ag/views/components/post_share_bottom_sheet.dart';
import 'package:sosyal_ag/view_models/main_screen_view_model.dart';

class MainScreen extends StatelessWidget {
  final BuildContext context;
  MainScreen({required this.context, super.key});

  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );
  final bool _hideNavBar = false;
  final NavBarStyle _navBarStyle = NavBarStyle.simple;

  List<Widget> _buildScreens() => [
    MainPage(),

    SearchPage(),

    MeydanPage(),

    MessagesPage(),

    ProfilePage(),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems(
    MainScreenViewModel mainScreenViewModel,
  ) => [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home),
      opacity: 0.7,
      activeColorPrimary: Colors.blue,
      activeColorSecondary: Theme.of(context).colorScheme.tertiary,
      inactiveColorPrimary: Theme.of(context).colorScheme.onSurface,
    ),

    PersistentBottomNavBarItem(
      icon: const Icon(Icons.search),
      activeColorPrimary: Colors.teal,
      activeColorSecondary: Theme.of(context).colorScheme.tertiary,
      inactiveColorPrimary: Theme.of(context).colorScheme.onSurface,
    ),

    PersistentBottomNavBarItem(
      icon: Image.asset(
        "assets/logo/m_light.png",
        width: MediaQuery.of(context).size.width * .07,
      ),
      opacity: 0.7,
      activeColorPrimary: Colors.blue,
      activeColorSecondary: Theme.of(context).colorScheme.tertiary,
      inactiveColorPrimary: Theme.of(context).colorScheme.onSurface,
    ),

    PersistentBottomNavBarItem(
      icon: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.message),
          Positioned(
            right: 0,
            top: 10,
            child: Container(
              height: 10,
              width: 10,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                "4",
                style: GoogleFonts.aBeeZee(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
            ),
          ),
        ],
      ),
      activeColorPrimary: Colors.deepOrange,
      inactiveColorPrimary: Theme.of(context).colorScheme.onSurface,
      activeColorSecondary: Theme.of(context).colorScheme.tertiary,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.person),
      activeColorPrimary: Colors.indigo,
      inactiveColorPrimary: Theme.of(context).colorScheme.onSurface,
      activeColorSecondary: Theme.of(context).colorScheme.tertiary,

      //scrollController: _scrollControllers.last,
    ),
  ];

  @override
  Widget build(final BuildContext context) {
    ThemeData theme = Theme.of(context);
    MainScreenViewModel mainScreenViewModel = Provider.of<MainScreenViewModel>(
      context,
    );

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(
      context,
      listen: true,
    );

    return Scaffold(
      appBar:
          mainScreenViewModel.isVisibleAppBar
              ? AppBar(
                actions: [
                  IconButton(
                    onPressed: () async {
                      await context.push("/notificationScreen");
                    },
                    icon: Icon(Icons.notifications),
                  ),
                ],
                title:
                    themeProvider.themeMode != ThemeMode.dark
                        ? Image.asset(
                          "assets/logo/meydan_dark.png",
                          height: 40,
                          //width: MediaQuery.of(context).size.width * .6,
                        )
                        : Image.asset(
                          "assets/logo/meydan_light.png",
                          height: 40,
                          //width: MediaQuery.of(context).size.width * .6,
                        ),

                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              )
              : null,

      drawer: MeydanDrawer(),

      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          print("main screen refreshed");
        },
        child: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),

          items: _navBarsItems(mainScreenViewModel),
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: false,
          stateManagement: true,
          hideNavigationBarWhenKeyboardAppears: true,
          popBehaviorOnSelectedNavBarItemPress: PopBehavior.once,
          hideOnScrollSettings: HideOnScrollSettings(
            hideNavBarOnScroll: true,
            scrollControllers: [],
          ),
          padding: const EdgeInsets.only(top: 8),
          onItemSelected: (index) => mainScreenViewModel.isAppBarVisible(index),
          floatingActionButton: Visibility(
            visible: mainScreenViewModel.isVisibleFloatingButton,
            child: Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 30),
              child: Container(
                height: 50,
                width: 50,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  shape: BoxShape.rectangle,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                child: IconButton(
                  padding: EdgeInsets.only(bottom: 30, right: 10),
                  icon: Icon(
                    Icons.add_comment_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    PostShareBottomSheet.show(context);
                  },
                ),
              ),
            ),
          ),
          onWillPop: (final context) async {
            await showDialog(
              context: context ?? this.context,
              useSafeArea: true,
              builder:
                  (final context) => Container(
                    height: 50,
                    width: 50,
                    color: Colors.white,
                    child: ElevatedButton(
                      child: const Text("Close"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
            );
            return false;
          },
          selectedTabScreenContext: (final context) {
            //testContext = context;
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          isVisible: !_hideNavBar,
          animationSettings: const NavBarAnimationSettings(
            navBarItemAnimation: ItemAnimationSettings(
              // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimationSettings(
              // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              duration: Duration(milliseconds: 300),
              screenTransitionAnimationType:
                  ScreenTransitionAnimationType.fadeIn,
            ),
            onNavBarHideAnimation: OnHideAnimationSettings(
              duration: Duration(milliseconds: 100),
              curve: Curves.bounceInOut,
            ),
          ),
          confineToSafeArea: true,
          navBarHeight: kBottomNavigationBarHeight,
          navBarStyle:
              _navBarStyle, // Choose the nav bar style with this property
        ),
      ),
    );
  }
}

// ----------------------------------------- Custom Style ----------------------------------------- //
