import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/utils/locator.dart';

// ignore: must_be_immutable
class PaginationMediaList extends StatelessWidget {
  final Init _init = locator<Init>();

  final ScrollController scrollController = ScrollController();


  PaginationMediaList({super.key});

  @override
  Widget build(BuildContext context) {
    // Burada SliverAppBar scroll'unun sağlıklı olması için
    // ListView kullanıyoruz. Yani yukar doğru kaydırdığımızda
    // SliverAppBar kaybolacak. Aşağı doğru kaydırdığımızda
    // SliverAppBar açılacak.
    // FirestorePagination'ı direkt kullandığımızda bu olmuyor.

 

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: FirestorePagination(
        limit: 15,
        isLive: true,
        viewType: ViewType.grid,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
        ),
        query: FirebaseFirestore.instance
            .collection('posts')
            .where("authorId", isEqualTo: _init.user?.uid)
            .where('hasMedia', isEqualTo: true)
            .orderBy('createdAt', descending: true),
        itemBuilder: (context, documentSnapshot, index) {

          if (documentSnapshot.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          final data = documentSnapshot[index].data() as Map<String, dynamic>;
          final post = PostModel.fromJson(data);
          
        


         for (var element in post.mediaUrls!) {
            return InkWell(
            onTap: () {
              context.push(
                "/postScreen",
                extra: {'post': post, 'author': _init.user!},
              );
            },
            child: Container(
              decoration: BoxDecoration(),
              child: Image.network(element.toString()),
            ),
          );
          }

          return const SizedBox.shrink(); // Eğer mediaUrls boşsa, boş bir widget döndür
          
          
        },
        initialLoader: const Center(child: CircularProgressIndicator()),
        bottomLoader: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
