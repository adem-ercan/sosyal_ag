import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/views/main_screen/main_page/post_card.dart';

class PaginationPostList extends StatelessWidget {

  

  const PaginationPostList({super.key});

  @override
  Widget build(BuildContext context) {
    return FirestorePagination(
      limit: 2,
      isLive: true,
      viewType: ViewType.list,
      bottomLoader: const Center(
        child: CircularProgressIndicator(strokeWidth: 3, color: Colors.blue),
      ),
      query: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true),
      itemBuilder: (context, documentSnapshot, index) {

        print(" ${index + 1} ${documentSnapshot[index].id}}");

        if (documentSnapshot.isEmpty){
           return Center(child: CircularProgressIndicator());
        }
         
        
        final data = documentSnapshot[index].data() as Map<String, dynamic>;

        final post = PostModel.fromJson(data);

        final authorId = post.authorId;

        // Fetch the author data using the authorId
        // For example, you can use a Firestore query to get the author data
        // Here, I'm assuming you have a method to fetch the author data

        return PostCard(post: post, author: UserModel(userName: "userName", email: "email"));
      },
    );
  }
}

/* class ProfilePageAlternative extends StatelessWidget {

  ProfilePageAlternative({super.key});

  final PagingController<int, PostModel> pagingController = PagingController(
    getNextPageKey: (PagingState<int, PostModel> state) {
      return (state.keys?.last ?? 0)+1;
    },
    fetchPage: (int pageKey) async {
      final Repository repository = locator<Repository>();
      return await repository.getMoreUserPosts(
        "sQcuYEWC8HfxLLEl0GXIxRsPqFI2",
        "dfyMX5OIDZVCBquLBD2n",
        9,
      );
    },
  );

  

  @override
  Widget build(BuildContext context) {
    return PagingListener(
      controller: pagingController,
      builder:
          (context, state, fetchNextPage) => PagedListView<int, PostModel>(
            state: state,
            fetchNextPage: fetchNextPage,
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder:
                  (context, item, index) => ListTile(
                    title: Container(
                      height: 100,
                      color: Colors.red,
                      child: Center(child: Text(item.content.toString())),
                    ),
                  ),
            ),
          ),
    );
  }
} */
