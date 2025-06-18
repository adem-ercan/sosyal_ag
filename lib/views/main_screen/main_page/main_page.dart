/* import 'package:flutter/material.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/views/main_screen/main_page/post_card.dart';


class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 30,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(8),
              child: PostCard(
                post: PostModel(
                  authorId: "dsfsdf",
                  content:
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                  mediaUrls:
                      index % 3 == 0
                          ? ["https://picsum.photos/500/300?random=$index"]
                          : null,
                ),
                author: UserModel(userName: "userName", email: "email"),
              ),
            );
          },
        ),
      ),
    );
  }
} */


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/view_models/user_view_model.dart';
import 'package:sosyal_ag/views/main_screen/main_page/post_card.dart';


class MainPage extends StatelessWidget {

  final Init _init = locator<Init>();

  MainPage({super.key});

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
              .collection('users')
              .doc(_init.user?.uid!)
              .collection('following'),
      
          itemBuilder: (context, documentSnapshot, index) {
            String followingID = documentSnapshot[index].id;
          
            if (documentSnapshot.isEmpty){
              return Center(child: CircularProgressIndicator());
            }
           
          // final data = documentSnapshot[index].data() as Map<String, dynamic>;
          // final post = PostModel.fromJson(data);
          
          /*  return FutureBuilder<UserModel?>(
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
          ); */
      
      
            return FirestorePagination(
              shrinkWrap: true,
              limit: 16,
              query: FirebaseFirestore.instance
                .collection('posts')
                .where("authorId", whereIn: [followingID])
                .orderBy('createdAt', descending: true),
              itemBuilder: (context, documentSnapshotX, index){
                if (documentSnapshotX.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                Map<String, dynamic> data = documentSnapshotX[index].data() as Map<String, dynamic>;
                PostModel post = PostModel.fromJson(data);
               
                return FutureBuilder<UserModel?>(
                  future: userViewModel.getUserDataById(followingID),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(child: Text('User not found'));
                    }

                    return PostCard(post: post, author: snapshot.data!);
                  }
                ); 
      
                /* return StreamBuilder(
                  stream: userViewModel.getUserByIdStream(followingID), 
                  builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(child: Text('User not found'));
                    }
                    Map<String, dynamic>? map = snapshot.data;
                    
                    UserModel user = UserModel.fromJson(map!);
                    return PostCard(post: post, author: user);
                  }); */
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



