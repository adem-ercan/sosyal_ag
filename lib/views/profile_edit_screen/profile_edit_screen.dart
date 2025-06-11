import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/view_models/profile_page_view_model.dart';

class ProfileEditScreen extends StatelessWidget {
  ProfileEditScreen({super.key});
  final Init _init = locator<Init>();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ProfilePageViewModel pageViewModel = Provider.of<ProfilePageViewModel>(
      context,
    );
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const Text('Profili Düzenle'),
        actions: [
          IconButton(
            onPressed: () {
              // Kaydetme işlemi
              pageViewModel.save();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _init.user!.photoUrl == null &&
                    pageViewModel.profilePhotoImages == null
                ? CircleAvatar(
                  backgroundColor: theme.colorScheme.secondary,
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png',
                  ),
                )
                : CircleAvatar(
                  backgroundColor: theme.colorScheme.secondary,
                  radius: 50,
                  backgroundImage:
                      pageViewModel.profilePhotoImages != null
                          ? FileImage(pageViewModel.profilePhotoImages!)
                          : NetworkImage('${_init.user!.photoUrl}'),
                ),

            TextButton(
              onPressed: () async {
                // Profil fotoğrafı değiştirme
                pageViewModel.mediaPick();
              },

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Fotoğrafı Değiştir',
                    style: GoogleFonts.aBeeZee(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.change_circle_outlined,
                    color: theme.colorScheme.onSecondary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: pageViewModel.formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _init.user?.name ?? "",
                    decoration: InputDecoration(
                      labelText: 'Ad Soyad',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.tertiary,
                          width: 2,
                        ),
                      ),
                      labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                      filled: true,
                      fillColor: theme.colorScheme.primary,
                      
                    ),

                    onSaved: (newValue) {
                      pageViewModel.fullName = newValue;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _init.user?.userName ?? "",
                    decoration: InputDecoration(
                      labelText: 'Kullanıcı Adı',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.tertiary,
                          width: 2,
                        ),
                      ),
                      labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                      filled: true,
                      fillColor: theme.colorScheme.primary,
                    ),
                    onSaved: (newValue) {
                      pageViewModel.userName = newValue;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _init.user?.bio ?? "",
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Biyografi',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.tertiary,
                          width: 2,
                        ),
                      ),
                      labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                      filled: true,
                      fillColor: theme.colorScheme.primary,
                    ),
                    onSaved: (newValue) {
                      pageViewModel.bio = newValue;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
