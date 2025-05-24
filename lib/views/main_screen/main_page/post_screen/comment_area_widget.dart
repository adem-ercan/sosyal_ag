import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/views/main_screen/main_page/post_screen/comment_card.dart';


class CommentAreaWidget extends StatelessWidget {

  PostModel postModel;

  CommentAreaWidget({
    super.key,
    required this.postModel,
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
              padding: EdgeInsets.all(16.0),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(postModel.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> data = 
                      snapshot.data!.data() as Map<String, dynamic>;
                    return ListView.builder(
                      reverse: true,
                      itemCount: data["comments"].length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return CommentCard(data: data, index: index);
                        
                        /* ListTile(
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
                        ); */
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            );
  }
}