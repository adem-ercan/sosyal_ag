import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {

  Map<String, dynamic> data;
  int index;

  CommentCard({
    
    required this.data,
    required this.index,
    super.key});

  String _getAyAdi(int ay) {
    const aylar = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return aylar[ay - 1];
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
              data["comments"][index]["userProfileImage"] ??
                  "https://picsum.photos/200/200?random=$index",
            ),
          ),
          const SizedBox(width: 12),
          // İçerik
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["comments"][index]["username"] ?? "kullanıcı",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(data["comments"][index]["content"] ?? "yorum içeriği"),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Sağ taraf
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data["comments"][index]["createdAt"] != null
                    ? "${data["comments"][index]["createdAt"].toDate().day} ${_getAyAdi(data["comments"][index]["createdAt"].toDate().month)} ${data["comments"][index]["createdAt"].toDate().year} ${data["comments"][index]["createdAt"].toDate().hour.toString().padLeft(2, '0')}:${data["comments"][index]["createdAt"].toDate().minute.toString().padLeft(2, '0')}"
                    : "Tarih",
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                    ),
                    icon: Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                    ),
                    icon: Icon(
                      Icons.remove_circle_outline,
                      size: 18,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
