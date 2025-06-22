
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/view_models/post_view_model.dart';
import 'package:sosyal_ag/view_models/user_view_model.dart';



// ignore: must_be_immutable
class CommentCard extends StatelessWidget {
  final Init _init = locator<Init>();

  // post verisi
  Map<String, dynamic> data;

  int index;

  // ignore: use_key_in_widget_constructors
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
      listen: false,
    );

    UserViewModel userViewModel = Provider.of<UserViewModel>(
      context,
      listen: false,
    );
    print("yorum data: ${data["authorId"]}");

    return FutureBuilder<UserModel?>(
      future: userViewModel.getUserDataById(data["authorId"]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Yorum bulunamadı!'));
        } else {
          UserModel author = snapshot.data!;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                FutureBuilder<UserModel?>(
                  future: userViewModel.getUserDataById(
                    data['comments'][index]["userId"],
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(child: Text('User not found'));
                    }
                    return InkWell(
                      onTap: (){
                        context.push('/otherUserProfile', extra: snapshot.data);
                      },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                          snapshot.data!.photoUrl ??
                              "https://picsum.photos/200/200?random=$index",
                        ),
                      ),
                    );
                  },
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
                            style: GoogleFonts.aBeeZee(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.6,
                              ),
                            ),
                          ),
                          const Spacer(),

                          Column(
                            children: [
                              StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>
                              >(
                                stream:
                                    FirebaseFirestore.instance
                                        .collection("posts")
                                        .doc(data["id"])
                                        .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      if (snapshot.data?.data() != null) {
                                        Map<String, dynamic>? dataPost =
                                            snapshot.data?.data();
                                        return SizedBox();
                                        /* return CommentLikeButton(
                                          user: _init.user?.uid ?? "",
                                          //likedUserIds: dataPost?["comments"][index]["likedUserIds"],
                                          commentData:
                                              dataPost?["comments"][index],
                                          postId: dataPost?["id"],
                                          index: index,
                                        ); */
                                      } else {
                                        return const Text("Yorum bulunamadı");
                                      }
                                    }
                                  }
                                },
                              ),
                            ],
                          ),

                          Visibility(
                            visible:
                                _init.user?.uid ==
                                data["comments"][index]["userId"],
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 30,
                                minHeight: 30,
                              ),
                              icon: Icon(
                                Icons.remove_circle_outline,
                                size: 18,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                              onPressed: () async {
                                await postViewModel.removeCommentFromPost(
                                  data["comments"][index],
                                );
                              },
                            ),
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
      },
    );
  }
}
