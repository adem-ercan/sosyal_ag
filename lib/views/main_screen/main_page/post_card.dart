import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/view_models/main_screen_view_model.dart';
import 'package:sosyal_ag/view_models/post_view_model.dart';
import 'package:sosyal_ag/view_models/user_view_model.dart';

class PostCard extends StatelessWidget {
  final Init _init = locator<Init>();

  final PostModel post;
  final UserModel author;
  final String? rePostUser;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onRepost;

  PostCard({
    super.key,
    required this.post,
    required this.author,
    this.rePostUser,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onRepost,
  });

  @override
  Widget build(BuildContext context) {
    PostViewModel postViewModel = Provider.of<PostViewModel>(
      context,
      listen: false,
    );

    MainScreenViewModel mainScreenViewModel = Provider.of<MainScreenViewModel>(
      context,
    );

    UserViewModel userViewModel = Provider.of<UserViewModel>(
      context,
      listen: false,
    );

    final theme = Theme.of(context);

    if (rePostUser == null) {
      return InkWell(
        onTap:
            onTap ??
            () {
              context.push(
                "/postScreen",
                extra: {'post': post, 'author': author},
              );
            },

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
                  InkWell(
                    onTap: () {
                      if (author.uid != _init.user!.uid) {
                        context.push('/otherUserProfile', extra: author);
                      } else {
                        mainScreenViewModel.controller.index = 3;
                        mainScreenViewModel.isFloatingButtonVisible(3);
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: theme.colorScheme.surface,
                      radius: 24,
                      backgroundImage:
                          author.photoUrl != null
                              ? NetworkImage(author.photoUrl!)
                              : null,
                      child:
                          author.photoUrl == null
                              ? Text(author.userName[0].toUpperCase())
                              : null,
                    ),
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
                                color: theme.colorScheme.onTertiary,
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
                              postViewModel.formatDate1(post.createdAt),
                              style: TextStyle(
                                color: theme.colorScheme.onTertiary,
                                fontSize: 10,
                              ),
                            ),
                            if (context.mounted) ...[
                              PopupMenuButton<String>(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                                onSelected: (value) async {
                                  if (value == 'delete') {
                                    await postViewModel.deletePost(
                                      context,
                                      post.id ?? "",
                                      author.uid ?? "",
                                      post.mediaUrls?[0],
                                    );
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
                                                      color:
                                                          theme
                                                              .colorScheme
                                                              .error,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Sil',
                                                      style: TextStyle(
                                                        color:
                                                            theme
                                                                .colorScheme
                                                                .error,
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
                                                      color:
                                                          theme
                                                              .colorScheme
                                                              .error,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Engelle',
                                                      style: TextStyle(
                                                        color:
                                                            theme
                                                                .colorScheme
                                                                .error,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          post.content,
                          style: GoogleFonts.aBeeZee(
                            fontSize: 15,
                            color: theme.colorScheme.onTertiary,
                          ),
                        ),
                        if (post.mediaUrls != null &&
                            post.mediaUrls!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () {
                              Map<String, dynamic> map = {
                                'mediaUrl': post.mediaUrls![0],
                                'author': author,
                                'post': post,
                              };
                              context.push("/mediaScreen", extra: map);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: post.mediaUrls!.first,
                              ),
                              /*  Image.network(
                              post.mediaUrls!.first,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: double.infinity,
                                  height: 200,
                                  color: theme.colorScheme.surface,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  ),
                                );
                              },
                            ),  */
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              // Alt kısım - Etkileşim butonları
              Padding(
                padding: const EdgeInsets.only(left: 60, top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInteractionButton(
                      icon: Icons.chat_bubble_outline,
                      count: post.commentsCount,
                      onTap: onComment,
                      color: Colors.grey,
                    ),
                    /*  _buildInteractionButton(
                      icon: Icons.repeat_rounded,
                      count: post.repostsCount,
                      onTap: onRepost,
                      color: theme.colorScheme.tertiary,
                    ), */
                    _buildInteractionButton(
                      icon: Icons.favorite_border,
                      count: post.likesCount,
                      onTap: onLike,
                      color: theme.colorScheme.error,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        weight: 5,
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
    } else {
      return FutureBuilder<UserModel?>(
        future: userViewModel.getUserDataById(rePostUser!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Post not found'));
          }

          UserModel rePostUser = snapshot.data!;

          return InkWell(
            onTap:
                onTap ??
                () {
                  context.push(
                    "/postScreen",
                    extra: {'post': post, 'author': author},
                  );
                },

            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor.withOpacity(0.2),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Üst kısım - Kullanıcı bilgileri
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.repeat, color: theme.colorScheme.tertiary),
                        Text(
                          "${rePostUser.name ?? rePostUser.userName} tarafından yeniden gönderi",
                          style: GoogleFonts.aBeeZee(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profil fotoğrafı
                      InkWell(
                        onTap: () {
                          if (author.uid != _init.user!.uid) {
                            context.push('/otherUserProfile', extra: author);
                          } else {
                            mainScreenViewModel.controller.index = 4;
                            mainScreenViewModel.isFloatingButtonVisible(4);
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: theme.colorScheme.surface,
                          radius: 24,
                          backgroundImage:
                              author.photoUrl != null
                                  ? NetworkImage(author.photoUrl!)
                                  : null,
                          child:
                              author.photoUrl == null
                                  ? Text(author.userName[0].toUpperCase())
                                  : null,
                        ),
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
                                    color: theme.colorScheme.onTertiary,
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
                                  postViewModel.formatDate1(
                                    post.rePostCreatedAt,
                                  ),
                                  style: TextStyle(
                                    color: theme.colorScheme.onTertiary,
                                    fontSize: 10,
                                  ),
                                ),
                                if (context.mounted) ...[
                                  PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                                    onSelected: (value) async {
                                      if (value == 'delete') {
                                        await postViewModel.deletePost(
                                          context,
                                          post.id ?? "",
                                          author.uid ?? "",
                                          post.mediaUrls?[0],
                                        );
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
                                                          color:
                                                              theme
                                                                  .colorScheme
                                                                  .error,
                                                          size: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          'Sil',
                                                          style: TextStyle(
                                                            color:
                                                                theme
                                                                    .colorScheme
                                                                    .error,
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
                                                          color:
                                                              theme
                                                                  .colorScheme
                                                                  .error,
                                                          size: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          'Engelle',
                                                          style: TextStyle(
                                                            color:
                                                                theme
                                                                    .colorScheme
                                                                    .error,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              post.content,
                              style: GoogleFonts.aBeeZee(
                                fontSize: 15,
                                color: theme.colorScheme.onTertiary,
                              ),
                            ),
                            if (post.mediaUrls != null &&
                                post.mediaUrls!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () {
                                  Map<String, dynamic> map = {
                                    'mediaUrl': post.mediaUrls![0],
                                    'author': author,
                                    'post': post,
                                  };
                                  context.push("/mediaScreen", extra: map);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: post.mediaUrls!.first,
                                  ),
                                  /*  Image.network(
                              post.mediaUrls!.first,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: double.infinity,
                                  height: 200,
                                  color: theme.colorScheme.surface,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  ),
                                );
                              },
                            ),  */
                                ),
                              ),
                            ],
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
                        _buildInteractionButtonForRepost(
                          icon: Icons.chat_bubble_outline,
                          count: post.commentsCount,
                          onTap: onComment,
                          color: Colors.grey,
                        ),
                        _buildInteractionButtonForRepost(
                          icon: Icons.repeat_rounded,
                          count: post.repostsCount,
                          onTap: onRepost,
                          color: theme.colorScheme.tertiary,
                        ),
                        _buildInteractionButtonForRepost(
                          icon: Icons.favorite_border,
                          count: post.likesCount,
                          onTap: onLike,
                          color: theme.colorScheme.error,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            weight: 5,
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
        },
      );
    }
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
          Icon(icon, size: 20, color: color, weight: 5),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(fontSize: 14, color: color.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButtonForRepost({
    required IconData icon,
    required int count,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color, weight: 5),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(fontSize: 14, color: color.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}
