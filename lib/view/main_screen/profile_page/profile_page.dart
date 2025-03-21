import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sosyal_ag/model/post_model.dart';
import 'package:sosyal_ag/model/user_model.dart';
import 'package:sosyal_ag/view/main_screen/main_page/post_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.colorScheme.tertiary,
                        theme.colorScheme.surface,
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
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: theme.colorScheme.tertiary,
                          child: const Icon(Icons.person, size: 40),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Kullanıcı Adı',
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.verified,
                                    color: theme.colorScheme.tertiary,
                                    size: 20,
                                  ),
                                ],
                              ),
                              Text(
                                '@kullaniciadi',
                                style: GoogleFonts.aBeeZee(
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.tertiary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Düzenle',
                            style: GoogleFonts.aBeeZee(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Biyografi yazısı burada yer alacak. Kullanıcının kendisi hakkında yazdığı kısa bilgi.',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn('Gönderi', '156'),
                        _buildStatColumn('Takipçi', '1.2K'),
                        _buildStatColumn('Takip', '843'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        'Gönderiler',
                        style: GoogleFonts.aBeeZee(),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Beğeniler',
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
            _buildPostsList(),
            _buildLikedList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.aBeeZee(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.aBeeZee(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildPostsList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return PostCard(
          post: PostModel(
            authorId: "test_id",
            content: "Test içerik $index",
          ),
          author: UserModel(
            userName: "Test Kullanıcı",
            email: "test@example.com",
          ),
        );
      },
    );
  }

  Widget _buildLikedList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return PostCard(
          post: PostModel(
            authorId: "test_id",
            content: "Beğenilen içerik $index",
          ),
          author: UserModel(
            userName: "Test Kullanıcı",
            email: "test@example.com",
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  Widget build(context, shrinkOffset, overlapsContent) => _tabBar;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
