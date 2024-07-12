import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/animated_play_pause_icon.dart';
import 'package:reddit_clone/video_controller_providers.dart';
import 'package:reddit_clone/video_controlling_button.dart';
import 'package:video_player/video_player.dart';

class VideoControllingWidget extends ConsumerWidget {
  const VideoControllingWidget({super.key});

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoPlayerControllingProvider =
        ref.watch(videoPlayerControllerProvider);

    return ValueListenableBuilder(
      valueListenable: videoPlayerControllingProvider.controller,
      builder: (context, VideoPlayerValue value, child) {
        final currentPosition = value.position;
        final totalDuration = value.duration;
        final progress = value.isInitialized
            ? currentPosition.inMilliseconds / totalDuration.inMilliseconds
            : 0.0;
        return ListTile(
          leading: AnimatedPlayPauseButton(
            value: value,
            icon: AnimatedIcons.pause_play,
            onTap: () {
              ref
                  .read(videoPlayerControllerProvider.notifier)
                  .playOrPauseOrRestart();
            },
          ),
          title: Row(
            children: [
              Expanded(
                  child: LinearProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.grey,
                      value: progress)),
              const SizedBox(
                width: 10,
              ),
              Text(
                formatDuration(currentPosition),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          trailing: VideoControllingButton(
            icon: videoPlayerControllingProvider.isMuted
                ? Icons.volume_off_outlined
                : Icons.volume_up_outlined,
            onTap: () {
              ref.read(videoPlayerControllerProvider.notifier).muteOrUnmute();
            },
          ),
        );
      },
    );
  }
}
