import 'package:apple_player/PlayerComponent/PlayerManager.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

class AudioPlayerComponent extends StatefulWidget {

  final String trackName;
  final String trackUrl;
  final Function selectTrackFunction;
  final int trackIndex;
  const AudioPlayerComponent({Key? key, required this.trackName, required this.trackUrl, required this.selectTrackFunction, required this.trackIndex}) : super(key: key);

  @override
  _AudioPlayerComponentState createState() => _AudioPlayerComponentState();
}

class _AudioPlayerComponentState extends State<AudioPlayerComponent> {
  late final PlayerManager _playerManager;

  @override
  void initState() {
    super.initState();
    //initialize PlayerManager with the track url to play track's preview
    _playerManager = PlayerManager(widget.trackUrl);
  }
  void dispose() {
    _playerManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //audio player consists of track name, track progress bar, and pause/play button
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
      child: Column(
        children: [
          Text(widget.trackName,overflow: TextOverflow.ellipsis),
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
                      //show selected playing song indicator when played
                      widget.selectTrackFunction(widget.trackIndex);
                    },
                  );
                case ButtonState.playing:
                  return IconButton(
                    icon: const Icon(Icons.pause),
                    iconSize: 32.0,
                    onPressed: () {
                      _playerManager.pause();
                      //hide selected playing song indicator when paused
                      widget.selectTrackFunction(-1);
                    },
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}