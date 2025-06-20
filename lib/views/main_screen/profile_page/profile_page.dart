import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/views/components/photo_thumbnail.dart';
import 'package:sosyal_ag/views/main_screen/profile_page/paginaition_liked_list.dart';
import 'package:sosyal_ag/views/main_screen/profile_page/pagination_favorited_post_list.dart';
import 'package:sosyal_ag/views/main_screen/profile_page/pagination_media_list.dart';
import 'package:sosyal_ag/views/main_screen/profile_page/pagination_post_list.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final Init _init = locator<Init>();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 4,
      child: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: theme.colorScheme.tertiary,
              title: Text(
                _init.user?.name ?? "",
                style: GoogleFonts.concertOne(
                  fontSize: 28,
                  color: theme.colorScheme.surface.withOpacity(.7),
                ),
              ),
              automaticallyImplyLeading: false,
              foregroundColor: theme.primaryColor,
              expandedHeight: 100,
              pinned: true,
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
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: IconButton(
                    onPressed: () {
                      context.push('/profileEdit');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: FittedBox(
                      child: Icon(Icons.edit, color: theme.colorScheme.onSurface),
                    ),
                  ),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _init.user!.photoUrl == null
                              ? CircleAvatar(
                                radius: 40,
                                backgroundColor: theme.colorScheme.tertiary,
                                child: const Icon(Icons.person, size: 40),
                              )
                              : 
                                 PhotoThumbnail(
                                  imageUrl: '${_init.user!.photoUrl}',
                                ),
                              
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        '@${_init.user?.userName}',
                                        style: GoogleFonts.aBeeZee(
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Visibility(
                                      visible:
                                          _init.user?.isVerified ?? false,
                                      child: Icon(
                                        Icons.verified,
                                        color: theme.colorScheme.tertiary,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                FittedBox(
                                  child: Text(
                                    _init.user?.email ?? "",
                                    style: GoogleFonts.aBeeZee(
                                      //fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${_init.user?.bio ?? " "} ',
                        //'Biyografi yazısı burada yer alacak. Kullanıcının kendisi hakkında yazdığı kısa bilgi.',
                        style: GoogleFonts.aBeeZee(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn(
                            'Gönderi',
                            '${_init.user?.posts?.length ?? "0"}',
                          ),
                          InkWell(
                            onTap: () {
                              context.push('/followersScreen');
                            },
                            child: _buildStatColumn(
                              'Takipçi',
                              '${_init.user?.followers?.length ?? "0"}',
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              context.push('/followingScreen');
                            },
                            child: _buildStatColumn(
                              'Takip',
                              '${_init.user?.following?.length ?? "0"}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  tabAlignment: TabAlignment.start,
                  automaticIndicatorColorAdjustment: false,
                  isScrollable: true,
                  dividerColor: theme.colorScheme.onSecondary,
                  labelColor: theme.colorScheme.tertiary,
                  overlayColor: WidgetStateProperty.all(
                    theme.colorScheme.primary,
                  ),
                  unselectedLabelColor: theme.colorScheme.onSurface,
                  tabs: [
                    Tab(
                      child: FittedBox(
                        child: Text('Gönderiler', style: GoogleFonts.aBeeZee()),
                      ),
                    ),
                    Tab(
                      child: FittedBox(
                        child: Text('Beğeniler', style: GoogleFonts.aBeeZee()),
                      ),
                    ),
                    Tab(
                      child: FittedBox(
                        child: Text(
                          'Kaydedilenler',
                          style: GoogleFonts.aBeeZee(),
                        ),
                      ),
                    ),
                    Tab(
                      child: FittedBox(
                        child: Text('Media', style: GoogleFonts.aBeeZee()),
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
            _buildLikedList(context),
            _buildSavedList(context),
            _buildMediaList(context),
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
          style: GoogleFonts.aBeeZee(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: GoogleFonts.aBeeZee(fontSize: 14)),
      ],
    );
  }

  Widget _buildPostsList(BuildContext context) {
    return PaginationPostList();
  }

  Widget _buildLikedList(BuildContext context) {
    return PaginationLikedPostList();
  }

  Widget _buildSavedList(BuildContext context) {
    return PaginationFavoritedPostList();
  }

  Widget _buildMediaList(BuildContext context) {
    return PaginationMediaList();
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
