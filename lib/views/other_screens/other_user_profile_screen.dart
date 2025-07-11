import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/view_models/user_view_model.dart';
import 'package:sosyal_ag/views/components/photo_thumbnail.dart';
import 'package:sosyal_ag/views/main_screen/main_page/post_card.dart';

class OtherUserProfileScreen extends StatelessWidget {
  final UserModel user;
  final Init _init = locator<Init>();
  late bool isFollowing;

  OtherUserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //isFollowing = _init.user!.following!.contains(user.uid);
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: DefaultTabController(
        length: 2,
        child: StreamBuilder<Map<String, dynamic>?>(
          stream: userViewModel.getUserByIdStream(_init.user!.uid.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic>? userMap = snapshot.data;
              List? fol = userMap!['following'] as List;

              isFollowing = fol.contains(user.uid);
              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 100,
                      floating: true,
                      pinned: true,
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: theme.colorScheme.onSurface,
                        ),
                        onPressed: () => context.pop(),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                theme.colorScheme.tertiary,
                                theme.scaffoldBackgroundColor,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                  user.photoUrl != null ? PhotoThumbnail(imageUrl: user.photoUrl!) :

                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: theme.colorScheme.tertiary,
                          
                                      
                                        
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            user.userName,
                                            style: GoogleFonts.aBeeZee(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (user.isVerified)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 4,
                                              ),
                                              child: Icon(
                                                Icons.verified,
                                                color:
                                                    theme.colorScheme.tertiary,
                                                size: 20,
                                              ),
                                            ),
                                        ],
                                      ),
                                      Text(
                                        '@${user.userName.toLowerCase()}',
                                        style: GoogleFonts.aBeeZee(
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (user.bio != null) ...[
                              const SizedBox(height: 16),
                              Text(
                                user.bio!,
                                style: GoogleFonts.aBeeZee(fontSize: 14),
                              ),
                            ],
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      isFollowing
                                          ? await userViewModel.unFollowUser(
                                            user.uid.toString(),
                                          )
                                          : await userViewModel.followUser(
                                            user.uid.toString(),
                                          );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          isFollowing
                                              ? theme.colorScheme.surface
                                              : theme.colorScheme.tertiary,
                                      foregroundColor:
                                          isFollowing
                                              ? theme.colorScheme.onSurface
                                              : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      isFollowing ? 'Takibi Bırak' : 'Takip Et',
                                      style:
                                          isFollowing
                                              ? GoogleFonts.aBeeZee(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    theme.colorScheme.onSurface,
                                              )
                                              : GoogleFonts.aBeeZee(
                                                fontWeight: FontWeight.bold,
                                                color: theme.primaryColor,
                                              ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () {},
                                  style: IconButton.styleFrom(
                                    backgroundColor: theme.colorScheme.surface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.message_outlined),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatColumn(
                                  context,
                                  'Gönderi',
                                  // Burası count olarak ayarlanabilir
                                  user.posts !=null ? user.posts!.length.toString() : '0',
                                ),
                                StreamBuilder<Map<String, dynamic>?>(
                                  stream: userViewModel.getUserByIdStream(user.uid.toString()),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      Map<String, dynamic>? data = snapshot.data;
                                      return _buildStatColumn(
                                      context,
                                      'Takipçi',
                                      data!['followers'] != null ? data['followers'].length.toString() : '0',
                                    );
                                    }

                                    return _buildStatColumn(
                                      context,
                                      'Takipçi',
                                      '0',
                                    );
                                  }
                                ),
                                _buildStatColumn(
                                  context,
                                  'Takip',
                                  user.following != null ? user.following!.length.toString() : '0',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          labelColor: theme.colorScheme.tertiary,
                          unselectedLabelColor: theme.colorScheme.onSurface,
                          tabs: [
                            Tab(
                              child: Text(
                                'Gönderiler',
                                style: GoogleFonts.aBeeZee(),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Medya',
                                style: GoogleFonts.aBeeZee(),
                              ),
                            ),
                          ],
                          indicatorColor: theme.colorScheme.tertiary,
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    _buildPostsList(context),
                    _buildMediaGrid(context),
                  ],
                ),
              );
            } else {
              return Center(child: Text("Bir sorun çıktı!"));
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.aBeeZee(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: GoogleFonts.aBeeZee(fontSize: 14)),
      ],
    );
  }

  Widget _buildPostsList(BuildContext context) {
    return FirestorePagination(
      limit: 5,
      isLive: true,
      query: FirebaseFirestore.instance
          .collection('posts')
          .where("authorId", isEqualTo: user.uid)
          .orderBy('createdAt', descending: true),
      itemBuilder: (context, documentSnapshot, index) {
        if (documentSnapshot.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        final data = documentSnapshot[index].data() as Map<String, dynamic>;
        final post = PostModel.fromJson(data);

        return PostCard(post: post, author: user);
      },
      initialLoader: const Center(child: CircularProgressIndicator()),
      bottomLoader: const Center(child: CircularProgressIndicator()),
    );
    /*  return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 10,
      itemBuilder: (context, index) {
        return PostCard(
          post: PostModel(
            authorId: user.uid ?? '',
            content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. $index",
          ),
          author: user,
        );
      },
    ); */
  }

  Widget _buildMediaGrid(BuildContext context) {
    return FirestorePagination(
      limit: 15,
      isLive: true,
      viewType: ViewType.grid,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      query: FirebaseFirestore.instance
          .collection('posts')
          .where("authorId", isEqualTo: user.uid)
          .where('hasMedia', isEqualTo: true)
          .orderBy('createdAt', descending: true),
      itemBuilder: (context, documentSnapshot, index) {
        if (documentSnapshot.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        final data = documentSnapshot[index].data() as Map<String, dynamic>;
        final post = PostModel.fromJson(data);

        for (var element in post.mediaUrls!) {
          return InkWell(
            onTap: () {
              context.push(
                "/postScreen",
                extra: {'post': post, 'author': user},
              );
            },
            child:Container(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.only(top:10, bottom: 0, left: 10, right: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child: Image.network(element.toString(), fit: BoxFit.cover,),
            ),
          );
        }

        return const SizedBox.shrink(); // Eğer mediaUrls boşsa, boş bir widget döndür
      },
      initialLoader: const Center(child: CircularProgressIndicator()),
      bottomLoader: const Center(child: CircularProgressIndicator()),
    );
    /* return GridView.builder(
      padding: const EdgeInsets.all(1),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return Container(
          color: Theme.of(context).colorScheme.surface,
          child: const Icon(Icons.image),
        );
      },
    ); */
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  Widget build(context, shrinkOffset, overlapsContent) => Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: _tabBar,
  );

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
