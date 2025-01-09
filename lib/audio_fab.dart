import 'package:flutter/material.dart';
import 'package:fluttio/models/theme.dart';
import 'package:fluttio/pages/detail_audio_page.dart';
import 'package:fluttio/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluttio/providers/audio_provider.dart';

class AudioFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AudioProvider, SettingsProvider>(
      builder: (context, audioProvider, setttingsProvider, child) {
        return audioProvider.currentPlayingTrack == null
            ? Container()
            : GestureDetector(
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailAudioPage(
                            track: audioProvider.currentPlayingTrack!)),
                  );
                },
                child: FloatingActionButton(
                  onPressed: () {
                    if (audioProvider.isPlaying) {
                      audioProvider.pause();
                    } else {
                      audioProvider.play();
                    }
                  },
                  child: Icon(
                    audioProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                ),
              );
      },
    );
  }
}
