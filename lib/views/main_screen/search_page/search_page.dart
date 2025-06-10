import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sosyal_ag/models/post_model.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/views/main_screen/main_page/post_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String? _searchQuery;
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

  

    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              TabBar(
                indicatorColor: theme.colorScheme.tertiary,
                labelColor: theme.colorScheme.tertiary,
                controller: _tabController,
                tabs: [Tab(text: 'Kullanıcı Ara'), Tab(text: 'Post Ara')],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SafeArea(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _isSearching = value.isNotEmpty;
                        _searchQuery = value.isNotEmpty ? value : null;
                      });
                      // TODO: Arama işlemi yapılacak
                    },
                    decoration: InputDecoration(
                      hintText:
                          _currentIndex == 0
                              ? 'Kullanıcı ara...'
                              : "Post ara...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon:
                          _isSearching
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _isSearching = false;
                                  });
                                },
                              )
                              : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // İlk tab - mevcut arama sonuçları
            _isSearching
                ? FirestorePagination(
                  limit: 15,
                  isLive: true,
                  viewType: ViewType.list,
                  shrinkWrap: true,
                  query: FirebaseFirestore.instance
                      .collection('users')
                      .orderBy("userName")
                      .startAt([_searchQuery!])
                      .endAt(['$_searchQuery\uf8ff']),

                  itemBuilder: (context, documentSnapshot, index) {

                    final data =
                        documentSnapshot[index].data() as Map<String, dynamic>;
                    final user = UserModel.fromJson(data);
                    return _buildUserListItem(user, theme);
                  },
                  initialLoader: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  bottomLoader: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 100,
                        color: theme.colorScheme.onSurface.withOpacity(0.2),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Kullanıcı aramak için yukarıdaki\narama çubuğunu kullan',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.aBeeZee(
                          fontSize: 16,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
            // İkinci tab
            _isSearching
                ? FirestorePagination(
                  limit: 15,
                  isLive: true,
                  viewType: ViewType.list,
                  shrinkWrap: true,
                  query: FirebaseFirestore.instance
                      .collection('posts')
                      .orderBy('createdAt', descending: true)
                      .where("searchKey", arrayContainsAny: _searchQuery!.split(' ')),
                     /*  .startAt([_searchQuery!])
                      .endAt(['$_searchQuery\uf8ff']), */
                      
                      
                                          
                  itemBuilder: (context, documentSnapshot, index) {
                    final data =
                        documentSnapshot[index].data() as Map<String, dynamic>;
                    final post = PostModel.fromJson(data);
                    return _buildPostListItem(
                      post,
                      UserModel(
                        userName: "ademmmm",
                        email: "ademmmm@gmail.com",
                      ),
                      theme,
                    );
                  },
                  initialLoader: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  bottomLoader: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 100,
                        color: theme.colorScheme.onSurface.withOpacity(0.2),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Post içeriği aramak için yukarıdaki\narama çubuğunu kullan',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.aBeeZee(
                          fontSize: 16,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserListItem(UserModel user, ThemeData theme) {
    return InkWell(
      onTap: () {
        // Kullanıcı profiline git
        context.push('/otherUserProfile', extra: user);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
          child:
              user.photoUrl == null
                  ? Text(user.userName[0].toUpperCase())
                  : null,
        ),
        title: Row(
          children: [
            Text(
              user.userName,
              style: GoogleFonts.aBeeZee(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (user.isVerified)
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
        subtitle: Text(
          '@${user.userName.toLowerCase()}',
          style: GoogleFonts.aBeeZee(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        trailing: TextButton(
          onPressed: () {
            print("Takip et butonuna basıldı");
          },
          child: Text(
            'Takip Et',
            style: GoogleFonts.aBeeZee(
              color: theme.colorScheme.tertiary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostListItem(PostModel post, UserModel user, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: PostCard(post: post, author: user),
    );
  }
}
