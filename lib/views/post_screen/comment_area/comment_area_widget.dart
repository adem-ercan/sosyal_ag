import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/views/post_screen/comment_area/comment_card.dart';

class CommentAreaWidget extends StatelessWidget {

  PostModel postModel;

  CommentAreaWidget({super.key, required this.postModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('posts')
                .doc(postModel.id)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data?.data() as Map<String, dynamic>;
            return ListView.builder(
              reverse: true,
              itemCount: data["comments"].length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CommentCard(data: data, index: index);
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
