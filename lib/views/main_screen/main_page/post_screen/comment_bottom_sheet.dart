import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/view_models/post_view_model.dart';

class CommentBottomSheet extends StatelessWidget {
  final String postId;

  const CommentBottomSheet({
    super.key,
    required this.postId,
  });

 

  
  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    PostViewModel postViewModel =
        Provider.of<PostViewModel>(context, listen: true);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Yorum Yap',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                   icon: Icon(Icons.send_rounded,
                  color: Theme.of(context).colorScheme.onSurface,),
                  onPressed: () async {
                    if (commentController.text.isNotEmpty) {
                      // Yorum gönderme işlemi
                      // Burada postViewModel.addCommentToPost() fonksiyonunu çağırabilirsiniz
                      // Örnek:
                     await postViewModel.addCommentToPost(
                        postId,
                        commentController.text
                      );
                    }
                   
                  },
                 
                  
                ),
              ],
            ),

            const SizedBox(height: 16),
            

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Yorumunuzu yazın...',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    maxLines: 3,
                    minLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                
              ],
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
