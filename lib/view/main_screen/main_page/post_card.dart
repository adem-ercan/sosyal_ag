import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sosyal_ag/model/post_model.dart';
import 'package:sosyal_ag/model/user_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final UserModel author;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onRepost;

  const PostCard({
    super.key,
    required this.post,
    required this.author,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onRepost,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst kısım - Kullanıcı bilgileri
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profil fotoğrafı
                CircleAvatar(
                  radius: 24,
                  backgroundImage: author.photoUrl != null
                      ? NetworkImage(author.photoUrl!)
                      : null,
                  child: author.photoUrl == null
                      ? Text(author.userName[0].toUpperCase())
                      : null,
                ),
                const SizedBox(width: 12),
                // Kullanıcı adı ve içerik
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            author.userName,
                            style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (author.isVerified)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.verified,
                                size: 16,
                                color: theme.colorScheme.tertiary,
                              ),
                            ),
                          const Spacer(),
                          Text(
                            '2s', // Burada gerçek zaman formatlaması yapılacak
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        post.content,
                        style: GoogleFonts.aBeeZee(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Alt kısım - Etkileşim butonları
            Padding(
              padding: const EdgeInsets.only(left: 60, top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInteractionButton(
                    icon: Icons.chat_bubble_outline,
                    count: post.commentsCount,
                    onTap: onComment,
                    color: Colors.grey,
                  ),
                  _buildInteractionButton(
                    icon: Icons.repeat_rounded,
                    count: post.repostsCount,
                    onTap: onRepost,
                    color: Colors.green,
                  ),
                  _buildInteractionButton(
                    icon: Icons.favorite_border,
                    count: post.likesCount,
                    onTap: onLike,
                    color: Colors.red,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.bookmark_border,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required int count,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color.withOpacity(0.6)),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 14,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
