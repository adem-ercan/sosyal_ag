import 'package:flutter/material.dart';

class CommentLikeButton extends StatelessWidget {
  
  final bool isLiked;
  final VoidCallback onTap;
  final int likeCount;

  const CommentLikeButton({
    super.key,
    required this.isLiked,
    required this.onTap,
    required this.likeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Column(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 30,
              minHeight: 30,
            ),
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              size: 18,
              color: isLiked 
                  ? Colors.red 
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            onPressed: onTap,
          ),
          Text(
            likeCount.toString(),
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
