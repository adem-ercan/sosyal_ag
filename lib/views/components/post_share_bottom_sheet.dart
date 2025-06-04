import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/view_models/post_view_model.dart';


class PostShareBottomSheet extends StatelessWidget {
  final Function(String content, List<String>? mediaUrls)? onPost;

  const PostShareBottomSheet({
    super.key,
    this.onPost,
  });

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
      ),
      builder: (context) => PostShareBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {

    final PostViewModel postViewModel = Provider.of<PostViewModel>(context);
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final TextEditingController contentController = TextEditingController();
    final List<String> selectedMediaUrls = [];

    return SafeArea(
      child: SizedBox(
        height: mediaQuery.size.height*.8,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            bottom: mediaQuery.viewInsets.bottom,
            left: 16,
            right: 16,
            top: 8,
          ),
          
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Kayan çubuk
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                // Başlık
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                    Text(
                      'Yeni Gönderi',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      // ignore: dead_code
                      onPressed: () => _handlePost(context, contentController.text, selectedMediaUrls),
                      child: postViewModel.loading == Loading.loading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.tertiary,
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Paylaş',
                                  style: GoogleFonts.aBeeZee(
                                    color: theme.colorScheme.tertiary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.send_rounded,
                                  color: theme.colorScheme.tertiary,
                                  size: 20,
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
                
                const Divider(),
                // İçerik
                TextField(
                  controller: contentController,
                  maxLines: 5,
                  maxLength: 280,
                  decoration: InputDecoration(
                    hintText: 'Ne düşünüyorsun?',
                    border: InputBorder.none,
                    counterStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
                // Medya önizleme
                if (postViewModel.image != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.file(postViewModel.image!),
                  )
                ],
                // Alt toolbar
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async => await postViewModel.mediaPick(),
                        icon: Icon(
                          Icons.image_outlined,
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.gif_box_outlined,
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                      
                      const Spacer(),
                      if (contentController.text.isNotEmpty)
                        Text(
                          '${contentController.text.length}/280',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: mediaQuery.padding.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildAddMediaButton(ThemeData theme, List<String> selectedMediaUrls) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: () => _pickImage(selectedMediaUrls),
        icon: Icon(
          Icons.add_photo_alternate_outlined,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildMediaPreview(String url, ThemeData theme, List<String> selectedMediaUrls) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 12,
          child: GestureDetector(
            onTap: () => _removeMedia(url, selectedMediaUrls),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 16,
                color: theme.colorScheme.onError,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _pickImage(List<String> selectedMediaUrls) {
    // TODO: Implement image picking
    print("Resim seçildi");
    selectedMediaUrls.add('https://picsum.photos/200');
  }

  void _removeMedia(String url, List<String> selectedMediaUrls) {
    selectedMediaUrls.remove(url);
  }

  void _handlePost(BuildContext context, String content, List<String>? mediaUrls) async {

    final PostViewModel postViewModel = Provider.of<PostViewModel>(context, listen: false);

    if (content.isEmpty){
      // Şimdilik sadece text paylaşımı yapalım.
      
      print("boş");
      return;
    }else{
      print("boş değil");
      await postViewModel.createNewPost(context, content);
    }

    try {
      await onPost?.call(content, mediaUrls);
      if (context.mounted) {
        Navigator.pop(context);
      }
      
    } catch (e) {
      // TODO: Handle error
    }
  }
}
