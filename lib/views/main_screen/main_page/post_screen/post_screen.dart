import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/view_models/post_view_model.dart';

class PostScreen extends StatelessWidget {
  /*  final PostModel post;
  final UserModel author; */

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

    PostViewModel postViewModel = Provider.of<PostViewModel>(context);

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
            Padding(
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
                                  mapData["author"]?.userName[0]
                                          .toUpperCase() ??
                                      "",
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
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
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
                      '14:30 · 12 Oca 2024',
                      style: GoogleFonts.aBeeZee(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),

                  const Divider(),
                  // Etkileşim sayıları
                  Row(
                    children: [
                      _buildStatText(
                        '${mapData["post"]?.likesCount}',
                        'Beğeni',
                      ),
                      const SizedBox(width: 24),
                      _buildStatText(
                        '${mapData["post"]?.commentsCount}',
                        'Yorum',
                      ),
                      const SizedBox(width: 24),
                      _buildStatText(
                        '${mapData["post"]?.repostsCount}',
                        'Yeniden Paylaşım',
                      ),
                    ],
                  ),
                  const Divider(),
                  // Etkileşim butonları
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(
                        icon: Icons.favorite_border,
                        label: 'Beğen',
                        onTap: () {},
                      ),
                      _buildActionButton(
                        icon: Icons.comment_outlined,
                        label: 'Yorum Yap',
                        onTap: () async {
                          PostModel postModel = mapData["post"];

                          postViewModel.showCommentSheet(
                            context,
                            postModel.id ?? "",
                          );
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.repeat,
                        label: 'Paylaş',
                        onTap: () {},
                      ),
                      _buildActionButton(
                        icon: Icons.bookmark_border,
                        label: 'Kaydet',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),

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

            Padding(
              padding: EdgeInsets.all(16.0),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(postModel.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> a = 
                      snapshot.data!.data() as Map<String, dynamic>;
                    return ListView.builder(
                      itemCount: a["comments"].length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(
                              a["comments"][index]["userProfileImage"] ?? "https://picsum.photos/200/200?random=$index",
                            ),
                          ),
                          title: Text(a["comments"][index]["username"] ?? "kullanıcı"),
                          subtitle: Text(a["comments"][index]["content"] ?? "yorum içeriği"),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: (){}, 
                                icon: Icon(Icons.remove_circle_outline, color: theme.colorScheme.error), ),
                             /*  Text(
                                a["comments"][index]["createdAt"] != null
                                    ? "${a["comments"][index]["createdAt"].toDate().day}/${a["comments"][index]["createdAt"].toDate().month}/${a["comments"][index]["createdAt"].toDate().year} ${a["comments"][index]["createdAt"].toDate().hour}:${a["comments"][index]["createdAt"].toDate().minute}"
                                    : "Tarih bilgisi yok",
                                style: GoogleFonts.aBeeZee(
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ), */
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),

            /*  Padding(
              padding: const EdgeInsets.all(16.0),
              child: FirestorePagination(
                limit: 6,
                isLive: true,
                physics: ClampingScrollPhysics(),
                viewType: ViewType.list,
                shrinkWrap: true,
                query: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(postModel.id)
                    .collection('comments')
                    .orderBy('createdAt', descending: true),
              
                // Burada postId'ye göre filtreleme yapılacak   
                itemBuilder: (context, documentSnapshot, index) {
                  print("yorum: ${index + 1} ${documentSnapshot[index].id}}");
              
                  if (documentSnapshot.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }
              
                 
              
                  // Burası CommentWidget olarak dışarı alınacak
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        "https://picsum.photos/200/200?random=$index",
                      ),
                    ),
                    title: Text("Commenter $index"),
                    subtitle: Text("This is a comment."),
                  );
                },
                initialLoader: const Center(child: CircularProgressIndicator()),
                bottomLoader: const Center(child: CircularProgressIndicator()),
              ),
            ),  */

            /* Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5, // TODO: Replace with actual comment count
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        "https://picsum.photos/200/200?random=$index",
                      ),
                    ),
                    title: Text("Commenter $index"),
                    subtitle: Text("This is a comment."),
                  );
                },
              ),
            ), */
          ],
        ),
      ),
    );
  }

  Widget _buildStatText(String count, String label) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.aBeeZee(fontSize: 14, color: Colors.grey),
        children: [
          TextSpan(
            text: '$count ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
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
