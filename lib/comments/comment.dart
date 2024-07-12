class Comment {
  final String id;
  final String username;
  final String content;
  final int daysAgo;
  final int upvotes;
  List<Comment> replies;

  Comment({
    required this.id,
    required this.username,
    required this.content,
    required this.daysAgo,
    required this.upvotes,
    List<Comment>? replies,
  }) : replies = replies ?? [];

  void addReply(Comment reply) {
    replies = List.from(replies)..add(reply);
  }
}
