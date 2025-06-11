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
import 'package:sosyal_ag/view_models/main_screen_view_model.dart';
import 'package:sosyal_ag/view_models/user_view_model.dart';
import 'package:sosyal_ag/views/main_screen/main_page/post_card.dart';

class SearchPage extends StatefulWidget {

  final Init init = locator<Init>();
  SearchPage({super.key});

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

    UserViewModel userViewModel = Provider.of<UserViewModel>(context, listen: false);
    MainScreenViewModel mainScreenViewModel = Provider.of<MainScreenViewModel>(context, listen: true);

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
                    return _buildUserListItem(user, theme, mainScreenViewModel, userViewModel);
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
                      post.authorId,
                      theme,
                      userViewModel
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

  Widget _buildUserListItem(UserModel user, ThemeData theme, MainScreenViewModel viewModel, UserViewModel userViewModel) {
    final Init init = locator<Init>();

    return InkWell(
      onTap: () {
        // Kullanıcı profiline git
        if(user.uid != init.user!.uid){
          context.push('/otherUserProfile', extra: user);
        }else{
          viewModel.controller.index = 4;
        }
        
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
          '@${user.userName}',
          style: GoogleFonts.aBeeZee(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        trailing: TextButton(
          onPressed: () async {
            print("Takip et butonuna basıldı");
            await userViewModel.followRequest(user.uid ?? "");

          },
          child: user.uid != init.user!.uid ? Text(
            'Takip Et',
            style: GoogleFonts.aBeeZee(
              color: theme.colorScheme.tertiary,
              fontWeight: FontWeight.bold,
            ),
          ) : Text(""),
        ),
      ),
    );
  }

  Widget _buildPostListItem(PostModel post, String userId, ThemeData theme, UserViewModel userViewModel) {
    return FutureBuilder<UserModel?>(
      future:  userViewModel.getUserDataById(userId),
      builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('User not found'));
                  }
                  return PostCard(post: post, author: snapshot.data!);
          
        
      }
    );
  }
}
