import 'package:flutter/material.dart';
import 'package:reddit_clone/comments/comment.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;
  final int depth;
  final Function(String, String?) onReply;

  const CommentWidget(
      {super.key,
      required this.comment,
      required this.onReply,
      this.depth = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF151114),
      child: Padding(
        padding: EdgeInsets.only(left: depth * 16.0, top: 8.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(child: Text(comment.username[0].toUpperCase())),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.username,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB1ADB0)),
                      ),
                      Text(
                        '${comment.daysAgo}d',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        comment.content,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.thumb_up,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            comment.upvotes.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            color: Colors.white,
                            icon: const Icon(Icons.reply, size: 16),
                            onPressed: () {
                              onReply(comment.id, null);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ...comment.replies.map((reply) => CommentWidget(
                comment: reply, onReply: onReply, depth: depth + 1)),
          ],
        ),
      ),
    );
  }
}
