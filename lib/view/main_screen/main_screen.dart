// Bu ekran test için oluşturuldu
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/model/post_model.dart';
import 'package:sosyal_ag/model/user_model.dart';
import 'package:sosyal_ag/view/main_screen/main_page/post_card.dart';
import 'package:sosyal_ag/view_model/user_view_model.dart';

/* import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/view_model/user_view_model.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          
          children: [
            Text('Main Screen' , style: GoogleFonts.aBeeZee(color: Theme.of(context).colorScheme.onSurface,fontSize: 20),),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () async => await userViewModel.signOut(), 
            child: Text('Sign Out')),
          ],
        ),
      ),
    );
  }
} */

// ----------------------------------------- Provided Style ----------------------------------------- //

class MainScreen extends StatelessWidget {
  final BuildContext context;

  MainScreen({required this.context, final Key? key}) : super(key: key);

  late PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );
  bool _hideNavBar = false;

  final List<ScrollController> _scrollControllers = [
    ScrollController(),
    ScrollController(),
  ];

  final NavBarStyle _navBarStyle = NavBarStyle.simple;

  List<Widget> _buildScreens() => [
    ListView.builder(
      controller: _scrollControllers[0],
      itemCount: 30,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(8),
          child: PostCard(post: PostModel(authorId: "dsfsdf", content: "content"), author: UserModel(userName: "userName", email: "email"))
        );
      },
    ),

    Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(child: TextField()),
      ),
    ),

    Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Center(child: Text("Screen3")),
    ),

    Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Center(child: Text("Screen4")),
    ),

    Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Center(child: Text("Screen5")),
    ),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home),
      title: "Home",
      opacity: 0.7,
      activeColorPrimary: Colors.blue,
      activeColorSecondary: Theme.of(context).colorScheme.tertiary,
      inactiveColorPrimary: Colors.grey,
    ),

    PersistentBottomNavBarItem(
      icon: const Icon(Icons.search),
      title: "Search",
      activeColorPrimary: Colors.teal,
      activeColorSecondary: Theme.of(context).colorScheme.tertiary,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.add),
      title: "Add",
      activeColorPrimary: Colors.blueAccent,
      inactiveColorPrimary: Colors.grey,
      activeColorSecondary: Theme.of(context).colorScheme.tertiary,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.message),
      title: "Messages",
      activeColorPrimary: Colors.deepOrange,
      inactiveColorPrimary: Colors.grey,
      activeColorSecondary: Theme.of(context).colorScheme.tertiary,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.person),
      title: "Profile",
      activeColorPrimary: Colors.indigo,
      inactiveColorPrimary: Colors.grey,
      activeColorSecondary: Theme.of(context).colorScheme.tertiary,
      scrollController: _scrollControllers.last,
    ),
  ];

  @override
  Widget build(final BuildContext context) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Screen"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),

      drawer: Drawer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("This is the Drawer"),
              ElevatedButton(
                onPressed: () async {
                  await userViewModel.signOut();
                },
                child: const Row(
                  children: [Icon(Icons.logout_outlined), Text("Sign Out")],
                ),
              ),
            ],
          ),
        ),
      ),

      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: false,
        stateManagement: true,
        hideNavigationBarWhenKeyboardAppears: true,
        popBehaviorOnSelectedNavBarItemPress: PopBehavior.once,
        hideOnScrollSettings: HideOnScrollSettings(
          hideNavBarOnScroll: true,
          scrollControllers: _scrollControllers,
        ),
        padding: const EdgeInsets.only(top: 8),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 30),
          child: Container(
            height: 50,
            width: 50,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  shape: BoxShape.rectangle,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
            child: IconButton(
              padding: EdgeInsets.only(bottom: 30, right: 10),
              icon: Icon(
                Icons.add_comment_rounded,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
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
            screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
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
    );
  }
}

// ----------------------------------------- Custom Style ----------------------------------------- //

class CustomNavBarWidget extends StatelessWidget {
  const CustomNavBarWidget(
    this.items, {
    required this.selectedIndex,
    required this.onItemSelected,
    final Key? key,
  }) : super(key: key);
  final int selectedIndex;
  // List<PersistentBottomNavBarItem> is just for example here. It can be anything you want like List<YourItemWidget>
  final List<PersistentBottomNavBarItem> items;
  final ValueChanged<int> onItemSelected;

  Widget _buildItem(
    final PersistentBottomNavBarItem item,
    final bool isSelected,
  ) => Container(
    alignment: Alignment.center,
    height: kBottomNavigationBarHeight,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: IconTheme(
            data: IconThemeData(
              size: 26,
              color:
                  isSelected
                      ? (item.activeColorSecondary ?? item.activeColorPrimary)
                      : item.inactiveColorPrimary ?? item.activeColorPrimary,
            ),
            child: isSelected ? item.icon : item.inactiveIcon ?? item.icon,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Material(
            type: MaterialType.transparency,
            child: FittedBox(
              child: Text(
                item.title ?? "",
                style: TextStyle(
                  color:
                      isSelected
                          ? (item.activeColorSecondary ??
                              item.activeColorPrimary)
                          : item.inactiveColorPrimary,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(final BuildContext context) => Container(
    color: Colors.grey.shade900,
    child: SizedBox(
      width: double.infinity,
      height: kBottomNavigationBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            items.map((final item) {
              final int index = items.indexOf(item);
              return Flexible(
                child: GestureDetector(
                  onTap: () {
                    onItemSelected(index);
                  },
                  child: _buildItem(item, selectedIndex == index),
                ),
              );
            }).toList(),
      ),
    ),
  );
}
