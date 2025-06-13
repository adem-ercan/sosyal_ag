import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/view_models/user_view_model.dart';

class FollowingScreen extends StatelessWidget {
  final Init _init = locator<Init>();
  
  FollowingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    UserViewModel userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Takip Edilenler',
          style: GoogleFonts.aBeeZee(color: theme.colorScheme.onTertiary),
        ),
      ),
      body: FirestorePagination(
        query: FirebaseFirestore.instance
            .collection('users')
            .doc(_init.user?.uid)
            .collection("following"),
            
            
            
            
        limit: 20,
        viewType: ViewType.list,
        onEmpty: Center(
          child: Text(
            'Henüz kimseyi takip etmiyorsunuz',
            style: GoogleFonts.aBeeZee(
              color: theme.colorScheme.onTertiary,
            ),
          ),
        ),
        bottomLoader: const Center(
          child: CircularProgressIndicator(),
        ),
        itemBuilder: (context, documentSnapshot, index) {
          final followingData = documentSnapshot[index].data() as Map<String, dynamic>;

         /*  return ListTile(
            title: Text("${followingData["followingId"]}")
          ); */
         return FutureBuilder<UserModel?>(
            future: userViewModel.getUserDataById(followingData['followingId'] ?? ""),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              
              final following = snapshot.data!;
              
              return InkWell(
                onTap: () {
                  context.push('/otherUserProfile', extra: following);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: following.photoUrl != null 
                        ? NetworkImage(following.photoUrl!) 
                        : null,
                    child: following.photoUrl == null 
                        ? Text(following.userName[0].toUpperCase())
                        : null,
                  ),
                  title: Row(
                    children: [
                      Text(
                        following.userName,
                        style: GoogleFonts.aBeeZee(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onTertiary,
                        ),
                      ),
                      if (following.isVerified)
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
                  subtitle: Text(
                    '@${following.userName.toLowerCase()}',
                    style: GoogleFonts.aBeeZee(
                      color: theme.colorScheme.onTertiary.withOpacity(0.6),
                    ),
                  ),
                  trailing: following.uid != _init.user?.uid
                      ? TextButton(
                          
                          onPressed: () async{
                            // Takipten çıkma işlemi
                            print("Takipten çık");
                            await userViewModel.unFollowUser(following.uid.toString());
                          },
                          child: Text(
                            'Takipten Çık',
                            style: GoogleFonts.aBeeZee(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.error,
                            ),
                          ),
                         
                        )
                      : null,
                ),
              );
            },
          ); 
        },
      ),
    );
  }
}
