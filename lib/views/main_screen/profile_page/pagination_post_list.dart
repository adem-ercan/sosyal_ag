import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/views/main_screen/main_page/post_card.dart';

class PaginationPostList extends StatelessWidget {

  final Init _init = locator<Init>();

  PaginationPostList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print("user id'ye bak: ${_init.user?.uid}");
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: FirestorePagination(
        limit: 6,
        isLive: true,
        physics: NeverScrollableScrollPhysics(),
        viewType: ViewType.list,
        shrinkWrap: true,
        query: FirebaseFirestore.instance
            .collection('posts')
            .where("authorId", isEqualTo: _init.user?.uid)
            .orderBy('createdAt', descending: true),
        itemBuilder: (context, documentSnapshot, index) {
      
          print(" ${index + 1} ${documentSnapshot[index].id}}");
        
          if (documentSnapshot.isEmpty){
            return Center(child: CircularProgressIndicator());
          }
      
          final data = documentSnapshot[index].data() as Map<String, dynamic>;
          final post = PostModel.fromJson(data);
      
          return PostCard(
            post: post,
            author: _init.user!,
          );
        },
        initialLoader: const Center(
          child: CircularProgressIndicator(),
        ),
        bottomLoader: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
