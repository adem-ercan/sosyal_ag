import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sosyal_ag/services/firebase/firebase_firestore_service.dart';
import 'package:sosyal_ag/utils/locator.dart';

class AboutScreen extends StatelessWidget {
   AboutScreen({super.key});

  final _service = locator<FirestoreService>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Hakkımızda'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<String>(
          future: _service.getAboutText(), 
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('User not found'));
                  }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(snapshot.data!, style: GoogleFonts.aBeeZee(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),),
            );
          }),
      ),
    );
  }
}