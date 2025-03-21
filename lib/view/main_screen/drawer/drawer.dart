import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/utils/theme_provider.dart';
import 'package:sosyal_ag/model/user_model.dart';
import 'package:sosyal_ag/view_model/user_view_model.dart';

class MeydanDrawer extends StatelessWidget {
  final UserModel? user;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;

  const MeydanDrawer({
    super.key,
    this.user,
    this.onProfileTap,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    UserViewModel userViewModel = Provider.of<UserViewModel>(context, listen: false);

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
              backgroundImage: user?.photoUrl != null 
                ? NetworkImage(user!.photoUrl!) 
                : null,
              child: user?.photoUrl == null
                  ? Text(
                      user?.userName.substring(0, 1).toUpperCase() ?? 'A',
                      style: const TextStyle(fontSize: 32),
                    )
                  : null,
            ),
            accountName: Row(
              children: [
                Text(
                  user?.userName ?? 'Kullanıcı Adı',
                  style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (user?.isVerified ?? false)
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
              user?.email ?? 'email@example.com',
              style: GoogleFonts.aBeeZee(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text('Profil', style: GoogleFonts.aBeeZee()),
            onTap: onProfileTap,
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: Text('Beğendiklerim', style: GoogleFonts.aBeeZee()),
            trailing: Text(
              '${user?.likedPosts?.length ?? 0}',
              style: GoogleFonts.aBeeZee(),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            title: Text('Favorilerim', style: GoogleFonts.aBeeZee()),
            trailing: Text(
              '${user?.favoritedPosts?.length ?? 0}',
              style: GoogleFonts.aBeeZee(),
            ),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            title: Text('Tema Değiştir', style: GoogleFonts.aBeeZee()),
            onTap: () => themeProvider.toggleTheme(),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text('Ayarlar', style: GoogleFonts.aBeeZee()),
            onTap: onSettingsTap,
          ),
          const Spacer(),
          Padding(
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
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
