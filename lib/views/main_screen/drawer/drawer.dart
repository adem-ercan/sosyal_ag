import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/utils/theme_provider.dart';
import 'package:sosyal_ag/view_models/main_screen_view_model.dart';
import 'package:sosyal_ag/view_models/user_view_model.dart';

class MeydanDrawer extends StatelessWidget {

  final Init _init = locator<Init>();
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  

   MeydanDrawer({
    super.key,
    this.onProfileTap,
    this.onSettingsTap,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    UserViewModel userViewModel = Provider.of<UserViewModel>(context, listen: false);
    MainScreenViewModel mainScreenViewModel = Provider.of<MainScreenViewModel>(context);

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.colorScheme.tertiary,
              backgroundImage: _init.user?.photoUrl != null 
                ? NetworkImage(_init.user!.photoUrl!) 
                : null,
              child: _init.user?.photoUrl == null
                  ? Text(
                      _init.user?.userName.substring(0, 1).toUpperCase() ?? 'A',
                      style: const TextStyle(fontSize: 32),
                    )
                  : null,
            ),
            accountName: Row(
              children: [
                Text(
                  _init.user?.userName ?? 'Kullanıcı Adı',
                  style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (_init.user?.isVerified ?? false)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.verified,
                      size: 16,
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
              ],
            ),
            accountEmail: Text(
              _init.user?.email ?? 'email@example.com',
              style: GoogleFonts.aBeeZee(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text('Profil', style: GoogleFonts.aBeeZee()),
            onTap: (){
             // Navigator.pop(context);
              mainScreenViewModel.isAppBarVisible(4);
              mainScreenViewModel.controller.index = 4;
              
            } 
          ),
            /* ListTile(
            leading: const Icon(Icons.person_add),
            title: Row(
              children: [
                Text('Takip İstekleri', style: GoogleFonts.aBeeZee()),
                SizedBox(width: MediaQuery.of(context).size.width*.2,),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Center(child: Text('5', style: GoogleFonts.aBeeZee(
                    fontSize: 12,
                    color: theme.colorScheme.tertiary, 
                    fontWeight: FontWeight.bold)))),
              ],
            ),
            onTap: () => context.push("/settingsScreen")
          ),
          */
          const Divider(),
          ListTile(
            leading: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            title: Text('Tema Değiştir', style: GoogleFonts.aBeeZee()),
            onTap: () async => await themeProvider.toggleTheme(),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text('Ayarlar', style: GoogleFonts.aBeeZee()),
            onTap: () => context.push("/settingsScreen")
          ),
          ListTile(
            leading: Icon(Icons.logout, color: theme.colorScheme.error,),
            title: Text('Oturumu Kapat', style: GoogleFonts.aBeeZee()),
            onTap: () async => await userViewModel.signOut()
          ),
          const Spacer(),
         /*  Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:  () async => await userViewModel.signOut(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.surface,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: Text(
                  'Çıkış Yap',
                  style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ), */
          //const SizedBox(height: 8),
        ],
      ),
    );
  }
}
