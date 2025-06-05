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

    UserViewModel userViewModel = Provider.of<UserViewModel>(
      context,
      listen: true,
    );

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
            .where("authorId", isEqualTo: _init.user!.uid)
            .where('mediaUrls')
            .orderBy('createdAt', descending: true),
        itemBuilder: (context, documentSnapshot, index) {
          print("bbb ${index + 1} ${documentSnapshot[index].id}}");

          if (documentSnapshot.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          final data = documentSnapshot[index].data() as Map<String, dynamic>;
          final post = PostModel.fromJson(data);
          if (post.mediaUrls == null || post.mediaUrls!.isEmpty) {
            return const SizedBox.shrink(); // Eğer mediaUrls boşsa, boş bir widget döndür
          }
          return Container(
            decoration: BoxDecoration(),
            child: Image.network(post.mediaUrls![index].toString()),
          );
        },
        initialLoader: const Center(child: CircularProgressIndicator()),
        bottomLoader: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
