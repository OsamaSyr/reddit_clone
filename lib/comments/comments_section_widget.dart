import 'package:flutter/material.dart';
import 'package:reddit_clone/comments/comment.dart';
import 'package:reddit_clone/comments/comment_widget.dart';

class CommentsSection extends StatelessWidget {
  final List<Comment> comments;
  final Function(String, String?) onReply;

  const CommentsSection(
      {super.key, required this.comments, required this.onReply});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return CommentWidget(comment: comments[index], onReply: onReply);
      },
    );
  }
}
