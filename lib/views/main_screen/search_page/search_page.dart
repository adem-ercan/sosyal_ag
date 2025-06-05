import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/view_models/user_view_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String? _searchQuery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    UserViewModel userViewModel = Provider.of<UserViewModel>(
      context,
      listen: true,
    );

    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
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
                  hintText: 'Kullanıcı ara...',
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
        ),
        body:
            _isSearching
                ? FutureBuilder<List<UserModel?>>(
                  future: userViewModel.searchUsers(_searchQuery!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final users = snapshot.data!;
                      if (users.isEmpty) {
                        return Center(
                          child: Text(
                            'Arama sonuç bulunamadı',
                            style: GoogleFonts.aBeeZee(
                              fontSize: 16,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.5,
                              ),
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          if (user == null) return SizedBox.shrink();
                          return _buildUserListItem(user, theme);
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Bir hata oluştu: ${snapshot.error}',
                          style: GoogleFonts.aBeeZee(
                            fontSize: 16,
                            color: theme.colorScheme.error,
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                      );
                    }
                  },
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
      ),
    );
  }

  Widget _buildUserListItem(UserModel user, ThemeData theme) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
        child:
            user.photoUrl == null ? Text(user.userName[0].toUpperCase()) : null,
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
          context.push(
            '/otherUserProfile',
            extra: UserModel(userName: "Adem", email: "ademercan@gmail.com"),
          );
        },
        child: Text(
          'Profili Gör',
          style: GoogleFonts.aBeeZee(
            color: theme.colorScheme.tertiary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
