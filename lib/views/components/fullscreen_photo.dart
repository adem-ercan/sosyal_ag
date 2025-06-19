import 'package:flutter/material.dart';

class FullScreenPhoto extends StatelessWidget {
  final String imageUrl;

  const FullScreenPhoto({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: InteractiveViewer( // Yakınlaştırma desteği
              child: Image.network(imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}