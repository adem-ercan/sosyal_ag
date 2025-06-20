import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
//import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/utils/theme_provider.dart';
import 'package:sosyal_ag/views/main_screen/drawer/drawer.dart';
import 'package:sosyal_ag/views/main_screen/main_page/main_page.dart';
import 'package:sosyal_ag/views/main_screen/meydan_page/meydan_page.dart';
import 'package:sosyal_ag/views/main_screen/profile_page/profile_page.dart';
import 'package:sosyal_ag/views/main_screen/search_page/search_page.dart';
import 'package:sosyal_ag/views/components/post_share_bottom_sheet.dart';
import 'package:sosyal_ag/view_models/main_screen_view_model.dart';
//import 'package:sosyal_ag/views/other_screens/notification_screen.dart';

class MainScreen extends StatelessWidget {
  final BuildContext context;
  final Init _init = locator<Init>();
  MainScreen({required this.context, super.key});

  
  final bool _hideNavBar = false;
  final NavBarStyle _navBarStyle = NavBarStyle.simple;

  List<Widget> _buildScreens() => [
    MeydanPage(),

    MainPage(),

    SearchPage(),

    //NotificationScreen(),

    //MessagesPage(),
    ProfilePage(),
  ];


  List<PersistentBottomNavBarItem> _navBarsItems(
    MainScreenViewModel mainScreenViewModel,
    ThemeMode themeMode,
  ) => [
    PersistentBottomNavBarItem(
      icon: Image.asset(
        themeMode == ThemeMode.dark
            ? "assets/logo/m_light.png"
            : "assets/logo/m_dark.png",
        width: MediaQuery.of(context).size.width * .07,
      ),


      opacity: 0.7,
      activeColorPrimary: Colors.blue,
      activeColorSecondary: Theme.of(context).colorScheme.tertiary,
      inactiveColorPrimary: Theme.of(context).colorScheme.onSurface,
    ),
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


    

    
    /* PersistentBottomNavBarItem(
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
    ), */

  /*   PersistentBottomNavBarItem(
      icon: Icon(Icons.notifications),
      activeColorPrimary: Colors.indigo,
      inactiveColorPrimary: Theme.of(context).colorScheme.onSurface,
      activeColorSecondary: Theme.of(context).colorScheme.tertiary,
      //scrollController: _scrollControllers.last,
    ), */

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
    MainScreenViewModel mainScreenViewModel = Provider.of<MainScreenViewModel>(context, listen: false);

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(
      context,
      listen: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //await themeProvider.toggleTheme();
      if (themeProvider.isFirst) {
        themeProvider.isFirst = false;
      
        await themeProvider.getUserTheme(_init.user?.uid ?? "");
      }
    });

    return Scaffold(
      appBar:  AppBar(
                actions: [
                  
                ],
                title:
                    themeProvider.themeMode != ThemeMode.dark
                        ? Image.asset(
                          "assets/logo/meydan_dark.png",
                          height: 30,
                          //width: diaQuery.of(context).size.width * .6,
                        )
                        : Image.asset(
                          "assets/logo/meydan_light.png",
                          height: 30,
                          //width: MediaQuery.of(context).size.width * .6,
                        ),

                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
         /*  mainScreenViewModel.isVisibleAppBar
              ? AppBar(
                actions: [
                  
                ],
                title:
                    themeProvider.themeMode != ThemeMode.dark
                        ? Image.asset(
                          "assets/logo/meydan_dark.png",
                          height: 30,
                          //width: diaQuery.of(context).size.width * .6,
                        )
                        : Image.asset(
                          "assets/logo/meydan_light.png",
                          height: 30,
                          //width: MediaQuery.of(context).size.width * .6,
                        ),

                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              )
              : null, */

      drawer: MeydanDrawer(),

      body: RefreshIndicator(
        onRefresh: () async {
          
          context.push('/');
          print("main screen refreshed");

          
        },
        child: PersistentTabView(
          context,
          controller: mainScreenViewModel.controller,
          screens: _buildScreens(),

          items: _navBarsItems(mainScreenViewModel, themeProvider.themeMode),
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          hideNavigationBarWhenKeyboardAppears: true,
          popBehaviorOnSelectedNavBarItemPress: PopBehavior.none,
          hideOnScrollSettings: HideOnScrollSettings(
            hideNavBarOnScroll: true,
            scrollControllers: [],
          ),
          padding: const EdgeInsets.only(top: 8),
          onItemSelected: (index) => mainScreenViewModel.isAppBarVisible(index),
          floatingActionButton: InkWell(
            onTap: () => PostShareBottomSheet.show(context),
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
                child: Icon(
                    Icons.add_comment_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                
              ),
            ),
          ),
          onWillPop: (final context) async {
  bool? shouldPop = await showDialog(
    context: context ?? this.context,
    barrierDismissible: false, // Dışarı tıklayınca kapanmasın
    builder: (final context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        'Çıkmak istediğinize emin misiniz?',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'Yaptığınız değişiklikler kaybolabilir.',
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Geri dönmesin
          },
          child: const Text(
            'Vazgeç',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            SystemNavigator.pop(); // Geri dönsün
          },
          child: const Text('Çık'),
        ),
      ],
    ),
  );

  return shouldPop ?? false;
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
