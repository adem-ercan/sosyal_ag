import 'package:flutter/material.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/views/main_screen/main_page/post_card.dart';


class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 30,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(8),
              child: PostCard(
                post: PostModel(
                  authorId: "dsfsdf",
                  content:
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                  mediaUrls:
                      index % 3 == 0
                          ? ["https://picsum.photos/500/300?random=$index"]
                          : null,
                ),
                author: UserModel(userName: "userName", email: "email"),
              ),
            );
          },
        ),
      ),
    );
  }
}

