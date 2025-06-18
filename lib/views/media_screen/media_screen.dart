import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/models/user_model.dart';

class MediaScreen extends StatelessWidget {
  final String mediaUrl;
  final PostModel post;
  final UserModel author;

  const MediaScreen({
    super.key,
    required this.mediaUrl,
    required this.post,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
         /*  IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Paylaşma işlemi
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Daha fazla seçenek
            },
          ), */
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              child: Center(
                child: Image.network(
                  mediaUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
           Container(
            padding: const EdgeInsets.all(16),
            color: theme.scaffoldBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               /*  Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: author.photoUrl != null
                          ? NetworkImage(author.photoUrl!)
                          : null,
                      child: author.photoUrl == null
                          ? Text(author.userName[0].toUpperCase())
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          author.userName,
                          style: GoogleFonts.aBeeZee(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onTertiary,
                          ),
                        ),
                        SingleChildScrollView(
                          child: Text(
                            post.content,
                            style: GoogleFonts.aBeeZee(
                              color: theme.colorScheme.onTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ), */
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(
                      icon: Icons.favorite_border,
                      label: '${post.likesCount}',
                      onTap: () {},
                      theme: theme,
                    ),
                    _buildActionButton(
                      icon: Icons.comment_outlined,
                      label: '${post.commentsCount}',
                      onTap: () {},
                      theme: theme,
                    ),
                    /* _buildActionButton(
                      icon: Icons.share,
                      label: 'Paylaş',
                      onTap: () {},
                      theme: theme,
                    ), */
                  ],
                ),
              ],
            ),
          ), 
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.onTertiary),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.aBeeZee(
                color: theme.colorScheme.onTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
