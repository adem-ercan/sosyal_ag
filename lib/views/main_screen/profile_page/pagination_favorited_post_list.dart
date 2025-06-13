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

class PaginationFavoritedPostList extends StatelessWidget {
  final Init _init = locator<Init>();

  final ScrollController scrollController = ScrollController();

  PaginationFavoritedPostList({super.key});

  @override
  Widget build(BuildContext context) {
    // Burada SliverAppBar scroll'unun sağlıklı olması için
    // ListView kullanıyoruz. Yani yukar doğru kaydırdığımızda
    // SliverAppBar kaybolacak. Aşağı doğru kaydırdığımızda
    // SliverAppBar açılacak.
    // FirestorePagination'ı direkt kullandığımızda bu olmuyor.


    UserViewModel userViewModel = Provider.of<UserViewModel>(
      context,
      listen: true,
    );
   
    return Container(
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
            .where("favoritedUsers", arrayContainsAny: [_init.user!.uid])
            .orderBy('createdAt', descending: true),
        itemBuilder: (context, documentSnapshot, index) {
          //print("likedPost ${index + 1} ${documentSnapshot[index].data()}");

          final data = documentSnapshot[index].data() as Map<String, dynamic>;
          final post = PostModel.fromJson(data);
          //return Center(child: Text("asfdasdfasf"));
          return FutureBuilder<UserModel?>(
            future: userViewModel.getUserDataById(post.authorId),
            builder: (context, snapshot) {
              UserModel? user = snapshot.data;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || user == null) {
                return const Center(child: Text('User not found'));
              }
              return PostCard(post: post, author:user);
            }
          );
        },
        initialLoader: const Center(child: CircularProgressIndicator()),
        bottomLoader: const Center(child: CircularProgressIndicator()),
      ),
    );


   
  }
}

