import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/view_models/post_view_model.dart';

class CommentLikeButton extends StatelessWidget {

  String user;
  Map<String,dynamic> commentData;
  String postId;
  int index;

  CommentLikeButton({
    required this.index,
    required this.postId,
    required this.commentData,
    required this.user,
    super.key});

  @override
  Widget build(BuildContext context) {
    PostViewModel postViewModel = Provider.of<PostViewModel>(
      context,
      listen: true,
    );
    return StreamBuilder<Object>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .snapshots(),
      builder: (context, snapshot) {
        return Visibility(
          child: Column(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                icon: Icon(
                  /* likedUserIds.contains(user) */ true ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color:
                      /* likedUserIds.contains(user) */
                      true
                          ? Colors.red
                          : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                ),
                onPressed: () async{
                  postViewModel.likeComment(postId, commentData, user);
                },
              ),
              Text(
                //likedUserIds.length.toString(),
                "1",
                style: GoogleFonts.aBeeZee(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
