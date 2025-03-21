import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sosyal_ag/model/user_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
                });
                // TODO: Arama işlemi yapılacak
              },
              decoration: InputDecoration(
                hintText: 'Kullanıcı ara...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
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
      body: _isSearching
          ? ListView.builder(
              itemCount: 10, // TODO: Gerçek veri sayısı kullanılacak
              itemBuilder: (context, index) {
                return _buildUserListItem(
                  UserModel(
                    userName: "Test User $index",
                    email: "test$index@example.com",
                    isVerified: index % 3 == 0,
                  ),
                  theme,
                );
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
    );
  }

  Widget _buildUserListItem(UserModel user, ThemeData theme) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: user.photoUrl != null
            ? NetworkImage(user.photoUrl!)
            : null,
        child: user.photoUrl == null
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
          // TODO: Profil görüntüleme işlemi
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
