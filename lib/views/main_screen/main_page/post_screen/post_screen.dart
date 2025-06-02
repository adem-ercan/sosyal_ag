import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/views/main_screen/main_page/post_screen/comment_area/comment_area_widget.dart';
import 'package:sosyal_ag/views/main_screen/main_page/post_screen/post_area/post_area_widget.dart';

class PostScreen extends StatelessWidget {

  /* final PostModel post;
  final UserModel author;  */

  final Map<String, dynamic> mapData;

  const PostScreen({
    super.key,
    required this.mapData,
    /* required this.post,
    required this.author, */
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    PostModel postModel = mapData["post"];
    print("gelen mapData: ${postModel.id}");


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
            onSelected: (value) {
              if (value == 'delete') {
                // TODO: Silme işlemi
                print('Post silinecek');
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: theme.colorScheme.error),
                        const SizedBox(width: 8),
                        Text(
                          'Sil',
                          style: TextStyle(color: theme.colorScheme.error),
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
