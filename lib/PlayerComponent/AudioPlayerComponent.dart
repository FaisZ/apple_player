import 'package:apple_player/PlayerComponent/PlayerManager.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

class AudioPlayerComponent extends StatefulWidget {
  const AudioPlayerComponent({Key? key}) : super(key: key);

  @override
  _AudioPlayerComponentState createState() => _AudioPlayerComponentState();
}

class _AudioPlayerComponentState extends State<AudioPlayerComponent> {
  late final PlayerManager _playerManager;

  @override
  void initState() {
    super.initState();
    _playerManager = PlayerManager();
  }
  void dispose() {
    _playerManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Spacer(),
              ValueListenableBuilder<ProgressBarState>(
                valueListenable: _playerManager.progressNotifier,
                builder: (_, value, __) {
                  return ProgressBar(
                    progress: value.current,
                    buffered: value.buffered,
                    total: value.total,
                    onSeek: _playerManager.seek,
                  );
                },
              ),
              ValueListenableBuilder<ButtonState>(
                valueListenable: _playerManager.buttonNotifier,
                builder: (_, value, __) {
                  switch (value) {
                    case ButtonState.loading:
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        width: 32.0,
                        height: 32.0,
                        child: const CircularProgressIndicator(),
                      );
                    case ButtonState.paused:
                      return IconButton(
                        icon: const Icon(Icons.play_arrow),
                        iconSize: 32.0,
                        onPressed: () {
                          _playerManager.play();
                        },
                      );
                    case ButtonState.playing:
                      return IconButton(
                        icon: const Icon(Icons.pause),
                        iconSize: 32.0,
                        onPressed: () {
                          _playerManager.pause();
                        },
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}