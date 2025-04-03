import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
        bottom: false,
        //maintainBottomViewPadding: true,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Column(
          children: [

            // Arama Çubuğu
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Mesajlarda ara...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
              ),
            ),
            
            // Mesaj Listesi
            Expanded(
              child: ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) {
                  return _MessageTile(
                    theme: theme,
                    isOnline: index % 3 == 0,
                    hasUnread: index % 4 == 0,
                  );
                },
              ),
            ),
          ],
        ),

        // Yeni Mesaj FAB

       /*  floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: theme.colorScheme.tertiary,
          child: const Icon(Icons.edit, color: Colors.white),
        ), */

      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  final ThemeData theme;
  final bool isOnline;
  final bool hasUnread;

  const _MessageTile({
    required this.theme,
    this.isOnline = false,
    this.hasUnread = false,    
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        
      },
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: theme.colorScheme.tertiary.withOpacity(0.2),
            child: const Icon(Icons.person),
          ),
          if (isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(
                    color: theme.scaffoldBackgroundColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Text(
            'Kullanıcı Adı',
            style: GoogleFonts.aBeeZee(
              fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 4),
          if (hasUnread)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '2',
                style: GoogleFonts.aBeeZee(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      subtitle: Text(
        'Son mesaj içeriği burada görünecek...',
        style: GoogleFonts.aBeeZee(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '14:30',
            style: GoogleFonts.aBeeZee(
              fontSize: 12,
              color: hasUnread 
                  ? theme.colorScheme.tertiary
                  : theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 4),
          if (isOnline)
            Text(
              'çevrimiçi',
              style: GoogleFonts.aBeeZee(
                fontSize: 12,
                color: Colors.green,
              ),
            ),
        ],
      ),
    );
  }
}
