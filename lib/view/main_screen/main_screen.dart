// Bu ekran test için oluşturuldu


import 'package:flutter/material.dart';
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
}