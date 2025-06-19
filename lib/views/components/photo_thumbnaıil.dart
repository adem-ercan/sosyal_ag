import 'package:flutter/material.dart';
import 'package:sosyal_ag/views/components/fullscreen_photo.dart';

class PhotoThumbnail extends StatelessWidget {
  final String imageUrl;

  const PhotoThumbnail({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) {
            return FullScreenPhoto(imageUrl: imageUrl);
          },
        ));
      },
      child: Hero(
        tag: imageUrl,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
