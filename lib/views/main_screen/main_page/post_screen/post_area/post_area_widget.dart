import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/view_models/post_view_model.dart';

class PostAreaWidget extends StatelessWidget {
  Map<String, dynamic> mapData;
  final Init _init = locator<Init>();

  PostAreaWidget({super.key, required this.mapData});

  // Bu kısım View Model'e taşınacak.

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    PostViewModel postViewModel = Provider.of<PostViewModel>(
      context,
      listen: true,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Yazar bilgileri
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage:
                    mapData["author"]?.photoUrl != null
                        ? NetworkImage(mapData["author"].photoUrl!)
                        : null,
                child:
                    mapData["author"]?.photoUrl == null
                        ? Text(
                          mapData["author"]?.userName[0].toUpperCase() ?? "",
                        )
                        : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          mapData["author"]?.userName ?? "",
                          style: GoogleFonts.aBeeZee(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (mapData["author"]?.isVerified ?? true)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.verified,
                              size: 16,
                              color: theme.colorScheme.tertiary,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      '@${mapData["author"]?.userName.toLowerCase()}',
                      style: GoogleFonts.aBeeZee(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Post içeriği
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              mapData["post"]?.content ??
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
              style: GoogleFonts.aBeeZee(fontSize: 16, height: 1.5),
            ),
          ),
          // Medya içeriği
          if (mapData["post"]?.mediaUrls != null &&
                  mapData["post"]?.mediaUrls!.isNotEmpty ||
              true)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "https://picsum.photos/500/300?random=3",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

          // Zaman bilgisi
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              postViewModel.formatDate(mapData["post"]?.createdAt),
              style: GoogleFonts.aBeeZee(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),

          const Divider(),
          // Etkileşim sayıları
          Row(
            children: [
              StreamBuilder<int>(
                stream: postViewModel.getPostLikesCountStream(
                  mapData["post"].id ?? "",
                ),
                builder: (context, snapshot) {
                  return RichText(
                    text: TextSpan(
                      style: GoogleFonts.aBeeZee(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      children: [
                        TextSpan(
                          text: snapshot.data?.toString() ?? '0 ',
                          style: GoogleFonts.aBeeZee(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        TextSpan(text: " Beğeni"),
                      ],
                    ),
                  );
                },
              ),

              /* _buildStatText(
                '${mapData["post"]?.likesCount}',
                'Beğeni',
                context,
              ), */
              const SizedBox(width: 24),
              _buildStatText(
                '${mapData["post"]?.commentsCount}',
                'Yorum',
                context,
              ),
              const SizedBox(width: 24),
              _buildStatText(
                '${mapData["post"]?.repostsCount}',
                'Yeniden Paylaşım',
                context,
              ),
            ],
          ),
          const Divider(),
          // Etkileşim butonları
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Beğen butonu
              StreamBuilder<List<String>>(
                stream: postViewModel.getLikedPostsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    );
                  } else {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    } else {
                      List<String>? likedPosts = snapshot.data;

                      print(
                        "liked posts: $likedPosts user id: ${_init.user?.uid}",
                      );

                      return InkWell(
                        onTap: () async {
                          await postViewModel.likePost(
                            mapData["post"].id ?? "",
                          );
                          // Burada beğenme işlemi yapılabilir
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              likedPosts!.contains(mapData['post'].id)
                                  ? Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 22,
                                  )
                                  : Icon(Icons.favorite_border, size: 22),
                              const SizedBox(height: 4),
                              Text(
                                "Beğen",
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 12,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }
                },
              ),

              _buildActionButton(
                icon: Icons.comment_outlined,
                label: 'Yorum Yap',
                onTap: () async {
                  PostModel postModel = mapData["post"];

                  postViewModel.showCommentSheet(context, postModel.id ?? "");
                },
              ),
              _buildActionButton(
                icon: Icons.repeat,
                label: 'Paylaş',
                onTap: () {},
              ),
              
              // Kaydet butonu
              StreamBuilder<List<String>>(
                stream: postViewModel.getSavedPostsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    );
                  } else {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    } else {
                      List<String>? likedPosts = snapshot.data;

                      print(
                        "liked posts: $likedPosts user id: ${_init.user?.uid}",
                      );

                      return InkWell(
                        onTap: () async {
                          await postViewModel.savePost(
                            mapData["post"].id ?? "",
                          );
                          // Burada beğenme işlemi yapılabilir
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              likedPosts!.contains(mapData['post'].id)
                                  ? Icon(
                                    Icons.bookmark,
                                    color: Colors.blue,
                                    size: 22,
                                  )
                                  : Icon(Icons.bookmark_border, size: 22),
                              const SizedBox(height: 4),
                              Text(
                                "Beğen",
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 12,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }
                },
              ),

              /* _buildActionButton(
                icon: Icons.bookmark_border,
                label: 'Kaydet',
                onTap: () async{
                  await postViewModel.savePost(
                    mapData["post"].id ?? ""
                  );
                },
              ), */
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatText(String count, String label, BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.aBeeZee(fontSize: 14, color: Colors.grey),
        children: [
          TextSpan(
            text: '$count ',
            style: GoogleFonts.aBeeZee(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          TextSpan(text: label),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Icon(icon, size: 22),
            const SizedBox(height: 4),
            Text(label, style: GoogleFonts.aBeeZee(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
