import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/video_controller_providers.dart';
import 'package:video_player/video_player.dart';

class AnimatedPlayPauseButton extends ConsumerStatefulWidget {
  const AnimatedPlayPauseButton(
      {super.key,
      required this.icon,
      required this.onTap,
      required this.value});
  final AnimatedIconData icon;
  final Function() onTap;
  final VideoPlayerValue value;

  @override
  ConsumerState<AnimatedPlayPauseButton> createState() =>
      _AnimatedPlayPauseButtonState();
}

class _AnimatedPlayPauseButtonState
    extends ConsumerState<AnimatedPlayPauseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.value.isCompleted) {
      ref.read(videoPlayerControllerProvider).controller.play();
      _controller.reverse();
      return;
    }
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    const double iconSize = 40.0;
    return InkWell(
      onTap: _handleTap,
      child: widget.value.isCompleted
          ? const Icon(Icons.refresh_outlined)
          : AnimatedIcon(
              icon: widget.icon,
              color: Colors.white,
              size: iconSize,
              progress: _animation,
            ),
    );
  }
}
