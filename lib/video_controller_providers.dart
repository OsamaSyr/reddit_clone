import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import "package:video_controls/video_controls.dart";

final videoPlayerControllerProvider = StateNotifierProvider<
    VideoPlayerControllerNotifier, VideoPlayerControllerRepository>((ref) {
  return VideoPlayerControllerNotifier();
});

class VideoPlayerControllerRepository {
  final VideoPlayerController controller;
  final bool isPlaying;
  final bool isMuted;

  VideoPlayerControllerRepository({
    required this.controller,
    this.isMuted = false,
    this.isPlaying = true,
  });

  VideoPlayerControllerRepository copyWith({bool? isPlaying, bool? isMuted}) {
    return VideoPlayerControllerRepository(
      controller: controller,
      isPlaying: isPlaying ?? this.isPlaying,
      isMuted: isMuted ?? this.isMuted,
    );
  }
}

class VideoPlayerControllerNotifier
    extends StateNotifier<VideoPlayerControllerRepository> {
  VideoPlayerControllerNotifier()
      : super(
          VideoPlayerControllerRepository(
            controller: VideoController.network(
                'https://j.top4top.io/m_31157c4ow1.mp4'),
          ),
        ) {
    _initializeController();
  }

  void _initializeController() async {
    await state.controller.initialize();
    state.controller.play();
    state = state.copyWith(isPlaying: true, isMuted: false);
  }

  void playOrPauseOrRestart() {
    if (state.controller.value.isCompleted) {
      state.controller.play();
      state = state.copyWith(isPlaying: true);
      return;
    }
    if (state.isPlaying) {
      state.controller.pause();
    } else {
      state.controller.play();
    }
    state = state.copyWith(isPlaying: !state.isPlaying);
  }

  void muteOrUnmute() {
    if (!state.isMuted) {
      state.controller.setVolume(0.0);
    } else {
      state.controller.setVolume(1.0);
    }
    state = state.copyWith(isMuted: !state.isMuted);
  }
}
