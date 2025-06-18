import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/view_models/post_view_model.dart';


class RepostBottomSheet extends StatelessWidget {
  PostModel post;

  bool isRepost;

   RepostBottomSheet({
    required this.isRepost,
    required this.post,
    super.key,
  });

  static Future<void> show(BuildContext context, {required bool isRepost, required PostModel post}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
      ),
      builder: (context) => RepostBottomSheet(isRepost: isRepost, post: post),
    );
  }

  @override
  Widget build(BuildContext context) {

    final PostViewModel postViewModel = Provider.of<PostViewModel>(context);
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: SizedBox(
        height: mediaQuery.size.height*.8,
        child: Column(

          children: [
            ElevatedButton(onPressed: ()async{
              //await postViewModel.rePost(post, context);
              if (context.mounted) {
                context.pop();
              }
            }, 
            child: Text(isRepost ? "Yeniden Gönder" : "Geri al"))
          ],
        ),
      )
    );
  }


}