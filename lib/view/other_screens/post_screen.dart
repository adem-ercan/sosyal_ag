import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostScreen extends StatelessWidget {
 /*  final PostModel post;
  final UserModel author; */
  
  final Map<String, dynamic> mapData;


  const PostScreen({
    super.key,
    required this.mapData
    /* required this.post,
    required this.author, */
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface),
            onPressed: () {
              // TODO: Show post options menu
            },
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
                        backgroundImage: mapData["author"]?.photoUrl != null
                            ? NetworkImage(mapData["author"].photoUrl!)
                            : null,
                        child: mapData["author"]?.photoUrl == null
                            ? Text(mapData["author"]?.userName[0].toUpperCase() ?? "")
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
                      mapData["post"]?.content ?? "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                      style: GoogleFonts.aBeeZee(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                  // Medya içeriği
                  if (mapData["post"]?.mediaUrls != null && mapData["post"]?.mediaUrls!.isNotEmpty || true)
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
                      '14:30 · 12 Oca 2024',  // TODO: Format real date
                      style: GoogleFonts.aBeeZee(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const Divider(),
                  // Etkileşim sayıları
                  Row(
                    children: [
                      _buildStatText('${mapData["post"]?.likesCount}', 'Beğeni'),
                      const SizedBox(width: 24),
                      _buildStatText('${mapData["post"]?.commentsCount}', 'Yorum'),
                      const SizedBox(width: 24),
                      _buildStatText('${mapData["post"]?.repostsCount}', 'Yeniden Paylaşım'),
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
                        onTap: () {},
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
          ],
        ),
      ),
    );
  }

  Widget _buildStatText(String count, String label) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.aBeeZee(
          fontSize: 14,
          color: Colors.grey,
        ),
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
            Text(
              label,
              style: GoogleFonts.aBeeZee(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
