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

class FollowersScreen extends StatelessWidget {
  final Init _init = locator<Init>();
  
  FollowersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    UserViewModel userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Takipçiler',
          style: GoogleFonts.aBeeZee(color: theme.colorScheme.onTertiary),
        ),
      ),
      body: FirestorePagination(
        query: FirebaseFirestore.instance
            .collection('users')
            .doc(_init.user?.uid)
            .collection('followers'),
        limit: 15,
        viewType: ViewType.list,
        onEmpty: Center(
          child: Text(
            'Henüz takipçiniz yok',
            style: GoogleFonts.aBeeZee(
              color: theme.colorScheme.onTertiary,
            ),
          ),
        ),
        bottomLoader: const Center(
          child: CircularProgressIndicator(),
        ),
        itemBuilder: (context, documentSnapshot, index) {
          final followerData = documentSnapshot[index].data() as Map<String, dynamic>;

          
          return FutureBuilder<UserModel?>(
            future: userViewModel.getUserDataById(followerData['followerId'] ?? ''),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              
              final follower = snapshot.data!;
              
              return InkWell(
                onTap: (){
                  context.push('/otherUserProfile', extra: follower);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: follower.photoUrl != null 
                        ? NetworkImage(follower.photoUrl!) 
                        : null,
                    child: follower.photoUrl == null 
                        ? Text(follower.userName[0].toUpperCase())
                        : null,
                  ),
                  title: Row(
                    children: [
                      Text(
                        follower.userName,
                        style: GoogleFonts.aBeeZee(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onTertiary,
                        ),
                      ),
                      if (follower.isVerified)
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
                    '@${follower.userName.toLowerCase()}',
                    style: GoogleFonts.aBeeZee(
                      color: theme.colorScheme.onTertiary.withOpacity(0.6),
                    ),
                  ),
                  trailing: follower.uid != _init.user?.uid
                      ? TextButton(
                          onPressed: () async {
                            // Takip et/Takibi bırak işlemi 
                            if (_init.user!.following!.contains(follower.uid)) {
                               await userViewModel.unFollowUser(follower.uid.toString());
                            }else{
                              
                              await userViewModel.followUser(follower.uid.toString());
                            }
                             
                          },
                          child: Text(
                            _init.user!.following!.contains(follower.uid) ? 'Takibi Bırak' : 'Takip Et',
                            style: GoogleFonts.aBeeZee(
                              color: theme.colorScheme.onTertiary,
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
