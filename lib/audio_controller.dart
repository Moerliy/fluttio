import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttio/models/theme.dart';
import 'package:fluttio/models/track.dart';
import 'package:fluttio/providers/audio_provider.dart';
import 'package:fluttio/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class AudioController extends StatefulWidget {
  final Track track;
  final AudioProvider audioProvider;
  const AudioController(
      {super.key, required this.track, required this.audioProvider});

  @override
  State<AudioController> createState() => _AudioControllerState();
}

class _AudioControllerState extends State<AudioController> {
  final List<IconData> _icons = [
    Icons.play_arrow,
    Icons.pause,
  ];

  @override
  void initState() {
    Track? currentTrack = widget.audioProvider.currentPlayingTrack;
    super.initState();
    if (currentTrack != null && currentTrack.id == widget.track.id) {
      widget.audioProvider.playNoNotify();
    } else {
      widget.audioProvider.playNoNotify(track: widget.track);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _btnStart() {
    return Consumer2<SettingsProvider, AudioProvider>(
        builder: (context, settingsProvider, audioProvider, child) {
      return IconButton(
        icon: Icon(_icons[audioProvider.isPlaying ? 1 : 0],
            size: 30,
            color: getColorMap(settingsProvider.themeFlavor)["mauve"]),
        onPressed: () {
          if (audioProvider.isPlaying) {
            audioProvider.pause();
          } else {
            audioProvider.play();
          }
        },
      );
    });
  }

  Widget _bntFast() {
    return Consumer<AudioProvider>(builder: (context, audioProvider, child) {
      return IconButton(
        icon: const Icon(Icons.fast_forward, size: 20),
        onPressed: () {
          audioProvider.setPlaybackRate(1.5);
        },
      );
    });
  }

  Widget _bntSlow() {
    return Consumer<AudioProvider>(builder: (context, audioProvider, child) {
      return IconButton(
        icon: const Icon(Icons.fast_rewind, size: 20),
        onPressed: () {
          audioProvider.setPlaybackRate(0.5);
        },
      );
    });
  }

  Widget _btnRepeat() {
    return Consumer2<SettingsProvider, AudioProvider>(
        builder: (context, settingsProvider, audioProvider, child) {
      return IconButton(
        icon: Icon(Icons.repeat,
            size: 20,
            color: getColorMap(settingsProvider.themeFlavor)[
                    audioProvider.isOnRepeat ? "mauve" : "text"] ??
                getColorMap(settingsProvider.themeFlavor)["text"]),
        onPressed: () {
          if (audioProvider.isOnRepeat) {
            audioProvider.stopRepeat();
          } else {
            audioProvider.repeat();
          }
        },
      );
    });
  }

  Widget _btnPlayBackRate() {
    return Consumer<AudioProvider>(builder: (context, audioProvider, child) {
      return IconButton(
        icon: Text(
          audioProvider.playbackRate.toString(),
          style: const TextStyle(fontSize: 15),
        ),
        onPressed: () {
          if (audioProvider.playbackRate != 1.0) {
            audioProvider.setPlaybackRate(1.0);
          }
        },
      );
    });
  }

  Widget _btn3DAudio() {
    return Consumer2<SettingsProvider, AudioProvider>(
        builder: (context, settingsProvider, audioProvider, child) {
      return IconButton(
        icon: Icon(Icons.audiotrack,
            size: 20,
            color: getColorMap(settingsProvider.themeFlavor)[
                    audioProvider.isOn3DAudio ? "mauve" : "text"] ??
                getColorMap(settingsProvider.themeFlavor)["text"]),
        onPressed: () {
          if (audioProvider.isOn3DAudio) {
            audioProvider.setIsOn3DAudio(false);
          } else {
            audioProvider.setIsOn3DAudio(true);
          }
        },
      );
    });
  }

  Widget _slider() {
    return Consumer2<SettingsProvider, AudioProvider>(
        builder: (context, settingsProvider, audioProvider, child) {
      return Slider(
        activeColor: getColorMap(settingsProvider.themeFlavor)["red"],
        inactiveColor: getColorMap(settingsProvider.themeFlavor)["text"],
        value: audioProvider.position.inSeconds.toDouble(),
        min: 0.0,
        max: audioProvider.duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            audioProvider.setAudioPosition(Duration(seconds: value.toInt()));
            value = value;
          });
        },
      );
    });
  }

  Widget _loadAsset() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _btnRepeat(),
          _bntSlow(),
          _btnStart(),
          _bntFast(),
          _btnPlayBackRate(),
          _btn3DAudio(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(builder: (context, audioProvider, child) {
      return Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      audioProvider.position.toString().split(".").first,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      audioProvider.duration.toString().split(".").first,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ]),
            ),
            _slider(),
            _loadAsset(),
            Text(
              'Balance: ${audioProvider.balance.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    });
  }
}
