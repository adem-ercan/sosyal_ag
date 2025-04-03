import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        title: Text(
          'Bildirimler',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: colorScheme.onSurfaceVariant),
            onPressed: () {
              // Bildirim ayarları sayfasına yönlendirme
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildNotificationGroup('Bugün'),
          _buildNotificationGroup('Bu Hafta'),
          _buildNotificationGroup('Bu Ay'),
        ],
      ),
    );
  }

  Widget _buildNotificationGroup(String title) {
    return LayoutBuilder(
      builder: (context, _) {
        final colorScheme = Theme.of(context).colorScheme;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            _buildNotificationItem(
              avatar: 'https://randomuser.me/api/portraits/women/1.jpg',
              username: 'Ayşe Yılmaz',
              action: 'gönderini beğendi',
              time: DateTime.now().subtract(const Duration(hours: 2)),
              type: NotificationType.like,
            ),
            _buildNotificationItem(
              avatar: 'https://randomuser.me/api/portraits/men/1.jpg',
              username: 'Mehmet Demir',
              action: 'seni takip etmeye başladı',
              time: DateTime.now().subtract(const Duration(hours: 5)),
              type: NotificationType.follow,
            ),
            _buildNotificationItem(
              avatar: 'https://randomuser.me/api/portraits/women/2.jpg',
              username: 'Zeynep Kaya',
              action: 'gönderine yorum yaptı',
              time: DateTime.now().subtract(const Duration(hours: 8)),
              type: NotificationType.comment,
            ),
          ],
        );
      }
    );
  }

  Widget _buildNotificationItem({
    required String avatar,
    required String username,
    required String action,
    required DateTime time,
    required NotificationType type,
  }) {
    return LayoutBuilder(
      builder: (context, _) {
        final colorScheme = Theme.of(context).colorScheme;
        return InkWell(
          onTap: () {
            // Bildirime özel sayfaya yönlendirme
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                bottom: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(avatar),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 14
                          ),
                          children: [
                            TextSpan(
                              text: username,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ' $action'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeago.format(time, locale: 'tr'),
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildNotificationIcon(type, colorScheme),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildNotificationIcon(NotificationType type, ColorScheme colorScheme) {
    
    IconData icon;
    Color color;


    switch (type) {
      case NotificationType.like:
        icon = Icons.favorite;
        color = colorScheme.error; // Beğeni için error rengi
        break;
      case NotificationType.comment:
        icon = Icons.comment;
        color = colorScheme.onSecondary; // Yorum için primary rengi
        break;
      case NotificationType.follow:
        icon = Icons.person_add;
        color = colorScheme.tertiary; // Takip için secondary rengi
        break;
    }

    return Icon(icon, color: color, size: 20);
  }
}

enum NotificationType {
  like,
  comment,
  follow,
}
