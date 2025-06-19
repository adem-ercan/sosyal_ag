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

  MeydanDrawer({super.key, this.onProfileTap, this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    UserViewModel userViewModel = Provider.of<UserViewModel>(
      context,
      listen: false,
    );
    MainScreenViewModel mainScreenViewModel = Provider.of<MainScreenViewModel>(
      context,
    );

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: theme.colorScheme.surface),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.colorScheme.tertiary,
              backgroundImage:
                  _init.user?.photoUrl != null
                      ? NetworkImage(_init.user!.photoUrl!)
                      : null,
              child:
                  _init.user?.photoUrl == null
                      ? Text(
                        _init.user?.userName.substring(0, 1).toUpperCase() ??
                            'A',
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
            onTap: () {
              // Navigator.pop(context);
              mainScreenViewModel.isAppBarVisible(3);
              mainScreenViewModel.controller.index = 3;
            },
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
            leading:
                themeProvider.themeMode == ThemeMode.dark
                    ? Image.asset("assets/logo/m_light.png", width: 20)
                    : Image.asset("assets/logo/m_dark.png", width: 20),
            title: Text(
              'Meydan Durumu',
              style: GoogleFonts.aBeeZee(color: theme.colorScheme.onTertiary),
            ),
            trailing: StreamBuilder<Map<String, dynamic>?>(
              stream: userViewModel.getUserByIdStream(_init.user!.uid ?? ""),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  snapshot.data!['isMeydan'];
                  return Switch(
                    activeColor: theme.colorScheme.tertiary,

                    value: snapshot.data!['isMeydan'],
                    onChanged: (value) async {
                      await userViewModel.toggleIsMeydan();
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),

          _init.user!.isVerified
              ? ListTile(
                leading: Icon(
                  Icons.verified,
                  color: theme.colorScheme.tertiary,
                ),
                title: Text('Hesap Onayını İptal Et', style: GoogleFonts.aBeeZee(color: theme.colorScheme.error)),
                onTap: () {
                  showCancelVerificationDialog(context);
                },
              )
              : ListTile(
                leading: Icon(
                  Icons.verified,
                  color: theme.colorScheme.tertiary,
                ),
                title: Text('Onaylı Hesaba Geç', style: GoogleFonts.aBeeZee()),
                onTap: () {
                  showVerificationRequestForm(context);
                },
              ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text('Ayarlar', style: GoogleFonts.aBeeZee()),
            onTap: () => context.push("/settingsScreen"),
          ),
          ListTile(
            leading: const Icon(Icons.info_outlined),
            title: Text('Hakkımızda', style: GoogleFonts.aBeeZee()),
            onTap: () => context.push("/about"),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text('Gizlilik Politikası', style: GoogleFonts.aBeeZee()),
            onTap: () => context.push("/policy"),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: theme.colorScheme.error),
            title: Text('Oturumu Kapat', style: GoogleFonts.aBeeZee()),
            onTap: () async => await userViewModel.signOut(),
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

  void showVerificationRequestForm(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String fullName = '';
    String reason = '';

    showDialog(
      context: context,
      builder: (context) {
        UserViewModel userViewModel = Provider.of<UserViewModel>(
          context,
          listen: false,
        );
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.verified, color: Colors.blueAccent),
              SizedBox(width: 8),
              Text('Mavi Tik Başvurusu'),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Ad Soyad'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Adınızı girin';
                      }
                      return null;
                    },
                    onSaved: (value) => fullName = value!,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Başvuru Nedeni'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Başvuru nedeninizi yazın';
                      }
                      return null;
                    },
                    onSaved: (value) => reason = value!,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'İptal',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  await userViewModel.toggleUserVerificationStatus(true);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Başvurunuz alınmıştır.')),
                    );
                  }
                }
              },
              child: Text('Başvur', style: GoogleFonts.aBeeZee(color: Theme.of(context).colorScheme.onSurface)),
            ),
          ],
        );
      },
    );
  }

  Future<void> showCancelVerificationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // Popup dışında tıklanınca kapanmasın
      builder: (context) {
        UserViewModel userViewModel = Provider.of<UserViewModel>(
          context,
          listen: false,
        );
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.cancel, color: Theme.of(context).colorScheme.error),
              SizedBox(width: 8),
              Text('Onayı İptal Et'),
            ],
          ),
          content: Text(
            'Hesap onayınızı iptal etmek istediğinizden emin misiniz? '
            'Bu işlem geri alınamaz ve mavi tikiniz kaldırılır.',
            style: GoogleFonts.aBeeZee(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Sadece popup kapanır
              },
              child: Text(
                'Vazgeç',
                style: GoogleFonts.aBeeZee(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                // Buraya onay iptal işlemini yaz
                // Örneğin: await viewModel.cancelVerification();
                userViewModel.toggleUserVerificationStatus(false);
                Navigator.of(context).pop(); // Popup kapansın
                // İstersen burada Snackbar da gösterebilirsin.
              },
              child: Text('Onayı İptal Et'),
            ),
          ],
        );
      },
    );
  }
}
