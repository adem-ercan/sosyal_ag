import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/view_models/user_view_model.dart';
import 'package:sosyal_ag/views/main_screen/main_page/post_card.dart';


class MeydanPage extends StatelessWidget {

 const MeydanPage({super.key});

  @override
  Widget build(BuildContext context) {
  

    UserViewModel userViewModel = Provider.of<UserViewModel>(
      context,
      listen: false,
    );

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: FirestorePagination(
          limit: 20,
          isLive: true,
          //physics: NeverScrollableScrollPhysics(),
          viewType: ViewType.list,
          shrinkWrap: true,
          query: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('createdAt', descending: true),
          itemBuilder: (context, documentSnapshot, index) {
        
          
            if (documentSnapshot.isEmpty){
              return Center(child: CircularProgressIndicator());
            }
        
            final data = documentSnapshot[index].data() as Map<String, dynamic>;
            final post = PostModel.fromJson(data);
      
        
            return FutureBuilder<UserModel?>(
              future: userViewModel.getUserDataById(post.authorId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('User not found'));
                }
                UserModel? user = snapshot.data;
      
                return PostCard(
                  post: post,
                  author: user!,
                );
              }
            );
          },
          initialLoader: const Center(
            child: CircularProgressIndicator(),
          ),
          bottomLoader: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

