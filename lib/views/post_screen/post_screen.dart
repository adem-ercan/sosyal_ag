import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/view_models/post_view_model.dart';
import 'package:sosyal_ag/views/post_screen/comment_area/comment_area_widget.dart';
import 'package:sosyal_ag/views/post_screen/post_area/post_area_widget.dart';

class PostScreen extends StatelessWidget {
  /* final PostModel post;
  final UserModel author;  */

  final Map<String, dynamic> mapData;
  final Init _init = locator<Init>();

  PostScreen({
    super.key,
    required this.mapData,
    /* required this.post,
    required this.author, */
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    PostModel postModel = mapData["post"];
    UserModel author = mapData["author"];
    PostViewModel postViewModel = Provider.of<PostViewModel>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface),
            onSelected: (value) async {
              if (value == 'delete') {
                await postViewModel.deletePost(
                  context,
                  postModel.id!,
                  author.uid!,
                  postModel.mediaUrls?[0],
                );
                if (context.mounted) {
                  context.pop();
                }
              }
            },
            itemBuilder:
                (BuildContext context) =>
                    _init.user?.uid == author.uid
                        ? <PopupMenuItem<String>>[
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: theme.colorScheme.error,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Sil',
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                        : <PopupMenuItem<String>>[
                          PopupMenuItem<String>(
                            value: 'block',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.block,
                                  color: theme.colorScheme.error,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Engelle',
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostAreaWidget(mapData: mapData),

            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                "Yorumlar",
                style: GoogleFonts.aBeeZee(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),

            CommentAreaWidget(postModel: postModel),
          ],
        ),
      ),
    );
  }
}
