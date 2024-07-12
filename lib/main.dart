import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/comments/comment.dart';
import 'package:reddit_clone/comments/comment_input_widget.dart';
import 'package:reddit_clone/comments/comment_widget.dart';
import 'package:reddit_clone/header_bar.dart';
import 'package:reddit_clone/video_controlling_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'video_controller_providers.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SafeArea(child: VideoPage()),
    );
  }
}

class VideoPage extends ConsumerStatefulWidget {
  const VideoPage({super.key});

  @override
  ConsumerState<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends ConsumerState<VideoPage> {
  late ScrollController _scrollController;
  bool isUpVoted = false;
  int totalUpVotes = 0;
  List<Comment> comments = [
    Comment(
      id: '1',
      username: 'احمد',
      content: 'ما اجمل فيروز و اغاني فيروز',
      daysAgo: 153,
      upvotes: 38,
    ),
    Comment(
        id: '3',
        username: 'Khaled Osama',
        content:
            'I love it when my dog sings with me! The neighbors probably don\'t.',
        daysAgo: 153,
        upvotes: 4,
        replies: [
          Comment(
              id: '4',
              username: 'Faisal',
              content: 'Same here! hahaha!',
              daysAgo: 153,
              upvotes: 2),
        ]),
    Comment(
      id: '4',
      username: 'حمودي',
      content: 'احب سماع اغاني فيروز مع القهوة!',
      daysAgo: 153,
      upvotes: 38,
    ),
  ];

  void _addComment(String content, String? parentId) {
    setState(() {
      if (parentId == null) {
        comments.add(Comment(
            id: const Uuid().v4(),
            username: 'NewUser',
            content: content,
            daysAgo: 0,
            upvotes: 0));
      } else {
        _addReplyToComment(
            comments,
            parentId,
            Comment(
                id: const Uuid().v4(),
                username: 'NewUser',
                content: content,
                daysAgo: 0,
                upvotes: 0));
      }
    });
  }

  void _addReplyToComment(
      List<Comment> comments, String parentId, Comment reply) {
    for (var comment in comments) {
      if (comment.id == parentId) {
        comment.addReply(reply);
        return;
      } else {
        _addReplyToComment(comment.replies, parentId, reply);
      }
    }
  }

  int _calculateTotalComments(List<Comment> comments) {
    int total = comments.length;
    for (var comment in comments) {
      total += _calculateTotalComments(comment.replies);
    }
    return total;
  }

  int _calculateTotalUpvotes(List<Comment> comments) {
    int total = 0;
    for (var comment in comments) {
      total += comment.upvotes;
      total += _calculateTotalUpvotes(comment.replies);
    }
    return total;
  }

  void vote() {
    print(isUpVoted);
    setState(() {
      if (!isUpVoted) {
        totalUpVotes++;
      } else {
        totalUpVotes--;
      }
      isUpVoted = !isUpVoted;
    });
  }

  @override
  void initState() {
    super.initState();
    totalUpVotes = _calculateTotalUpvotes(comments);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF0E1015),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPersistentHeader(
            delegate: VideoHeaderDelegate(
              ref: ref,
              minExtent: size.height * 0.3,
              maxExtent: size.height * 0.85,
            ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Container(
              height: size.height * 0.05,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(children: [
                      InkWell(
                        onTap: vote,
                        child: Icon(
                          Icons.arrow_upward_outlined,
                          color: isUpVoted ? Colors.blue : Colors.white,
                          size: isUpVoted ? 40 : 30,
                        ),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        '$totalUpVotes',
                        style: const TextStyle(color: Colors.white),
                      )
                    ]),
                    const Spacer(flex: 1),
                    const Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                      size: 30,
                    ),
                    const Spacer(flex: 1),
                    Row(children: [
                      const Icon(
                        Icons.chat_bubble_outline_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${_calculateTotalComments(comments)}',
                        style: const TextStyle(color: Colors.white),
                      )
                    ]),
                    const Spacer(flex: 10),
                    const Icon(
                      Icons.ios_share_outlined,
                      color: Colors.white,
                      size: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < comments.length) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommentWidget(
                        comment: comments[index],
                        onReply: (parentId, _) {
                          _showCommentInput(parentId);
                        }),
                  );
                }
                return null;
              },
              childCount: comments.length,
            ),
          ),
          SliverToBoxAdapter(
            child: CommentInput(
              onSubmit: (content, p1) {
                setState(() {
                  comments.add(Comment(
                      id: const Uuid().v6(),
                      username: 'Osama Abdullah',
                      content: content,
                      daysAgo: 0,
                      upvotes: 0));
                });
              },
            ),
          )
        ],
      ),
    );
  }

  void _showCommentInput(String parentId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: const Color(0xFF0E1015),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: CommentInput(onSubmit: (content, p0) {
              _addComment(content, parentId);
            }),
          ),
        );
      },
    );
  }
}

class VideoHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  final double minExtent;
  @override
  final double maxExtent;

  final WidgetRef ref;

  VideoHeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.ref,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final Size size = MediaQuery.of(context).size;
    final videoControllerProvider = ref.watch(videoPlayerControllerProvider);
    final videoHeight = (maxExtent - shrinkOffset).clamp(minExtent, maxExtent);
    return Container(
      height: videoHeight,
      width: double.infinity,
      color: Colors.black,
      child: Center(
        child: ValueListenableBuilder(
          valueListenable: videoControllerProvider.controller,
          builder: (context, VideoPlayerValue value, child) {
            if (value.isInitialized) {
              return SizedBox(
                height: videoHeight,
                width: videoHeight * value.aspectRatio,
                child: AspectRatio(
                  aspectRatio: value.aspectRatio,
                  child: Stack(
                    children: [
                      VideoPlayer(videoControllerProvider.controller),
                      Positioned(
                          top: size.width * 0.03,
                          left: 0,
                          right: 0,
                          child: VideoHeaderBar(videoHeight)),
                      Positioned(
                          bottom: size.width * 0.05,
                          left: 0,
                          right: 0,
                          child: (videoHeight >= size.height * 0.8)
                              ? const VideoControllingWidget()
                              : const SizedBox()),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
