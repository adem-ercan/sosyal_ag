import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/utils/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ayarlar',
          style: GoogleFonts.aBeeZee(
            color: theme.colorScheme.onTertiary,
          ),
        ),
      ),
      body: ListView(
        children: [
          // Tema Ayarları
          ListTile(
            leading: Icon(Icons.dark_mode, color: theme.colorScheme.onTertiary),
            title: Text(
              'Karanlık Mod',
              style: GoogleFonts.aBeeZee(color: theme.colorScheme.onTertiary),
            ),
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
          ),
          const Divider(),

          // Bildirim Ayarları
          ListTile(
            leading: Icon(Icons.notifications, color: theme.colorScheme.onTertiary),
            title: Text(
              'Bildirim Ayarları',
              style: GoogleFonts.aBeeZee(color: theme.colorScheme.onTertiary),
            ),
            trailing: Icon(Icons.arrow_forward_ios, 
              color: theme.colorScheme.onTertiary,
              size: 16,
            ),
            onTap: () {
              // Bildirim ayarları sayfasına yönlendir
            },
          ),
          const Divider(),

          // Hesap Ayarları
          ListTile(
            leading: Icon(Icons.person, color: theme.colorScheme.onTertiary),
            title: Text(
              'Hesap Ayarları',
              style: GoogleFonts.aBeeZee(color: theme.colorScheme.onTertiary),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
              color: theme.colorScheme.onTertiary,
              size: 16,
            ),
            onTap: () {
              // Hesap ayarları sayfasına yönlendir
            },
          ),
          const Divider(),

          // Gizlilik Ayarları
          ListTile(
            leading: Icon(Icons.security, color: theme.colorScheme.onTertiary),
            title: Text(
              'Gizlilik',
              style: GoogleFonts.aBeeZee(color: theme.colorScheme.onTertiary),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
              color: theme.colorScheme.onTertiary,
              size: 16,
            ),
            onTap: () {
              // Gizlilik sayfasına yönlendir
            },
          ),
          const Divider(),

          // Yardım ve Destek
          ListTile(
            leading: Icon(Icons.help, color: theme.colorScheme.onTertiary),
            title: Text(
              'Yardım ve Destek',
              style: GoogleFonts.aBeeZee(color: theme.colorScheme.onTertiary),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
              color: theme.colorScheme.onTertiary,
              size: 16,
            ),
            onTap: () {
              // Yardım sayfasına yönlendir
            },
          ),
          const Divider(),

          // Uygulama Hakkında
          ListTile(
            leading: Icon(Icons.info, color: theme.colorScheme.onTertiary),
            title: Text(
              'Hakkında',
              style: GoogleFonts.aBeeZee(color: theme.colorScheme.onTertiary),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
              color: theme.colorScheme.onTertiary,
              size: 16,
            ),
            onTap: () {
              // Hakkında sayfasına yönlendir
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
