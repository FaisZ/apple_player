import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerManager {
  // static const url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3';
  static const url = 'https://video-ssl.itunes.apple.com/itunes-assets/Video118/v4/be/9a/18/be9a18de-2e1f-4917-6973-ab4035978aa1/mzvf_5776119663544478994.640x352.h264lc.U.p.m4v';
  late AudioPlayer _audioPlayer;

  PlayerManager() {
    _init();
  }

  void play() {
    _audioPlayer.play();
  }
  void pause() {
    _audioPlayer.pause();
  }
  void dispose() {
    _audioPlayer.dispose();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }
  void _init() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setUrl(url);
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else { // completed
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });
    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });
    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState {
  paused, playing, loading
}

