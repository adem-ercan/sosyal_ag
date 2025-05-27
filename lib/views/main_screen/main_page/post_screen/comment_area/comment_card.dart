import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/view_models/post_view_model.dart';
import 'package:sosyal_ag/views/main_screen/main_page/post_screen/comment_area/comment_like_button.dart';

class CommentCard extends StatelessWidget {
  Map<String, dynamic> data;


  int index;

  CommentCard({required this.data, required this.index, super.key});

  String _getAyAdi(int ay) {
    const aylar = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
    ];
    return aylar[ay - 1];
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    PostViewModel postViewModel = Provider.of<PostViewModel>(
      context,
      listen: true,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
              data["comments"][index]["userProfileImage"] ??
                  "https://picsum.photos/200/200?random=$index",
            ),
          ),
          const SizedBox(width: 12),
          // İçerik
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["comments"][index]["username"] ?? "kullanıcı",
                  style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  data["comments"][index]["content"] ?? "yorum içeriği",
                  style: GoogleFonts.aBeeZee(
                    color: theme.colorScheme.tertiary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      data["comments"][index]["createdAt"] != null
                          ? "${data["comments"][index]["createdAt"].toDate().day} ${_getAyAdi(data["comments"][index]["createdAt"].toDate().month)} ${data["comments"][index]["createdAt"].toDate().year} ${data["comments"][index]["createdAt"].toDate().hour.toString().padLeft(2, '0')}:${data["comments"][index]["createdAt"].toDate().minute.toString().padLeft(2, '0')}"
                          : "Tarih",
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        CommentLikeButton(
                          isLiked: true,
                          onTap: () {},
                          likeCount: 2,
                        ),
                      ],
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                      icon: Icon(
                        Icons.remove_circle_outline,
                        size: 18,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      onPressed: () async {
                        await postViewModel.removeCommentFromPost(
                          data["comments"][index],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
