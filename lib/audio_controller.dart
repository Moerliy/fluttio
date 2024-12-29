import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttio/models/theme.dart';
import 'package:fluttio/providers/gyro_provider.dart';
import 'package:fluttio/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class AudioController extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final String url;
  final GyroProvider gyroProvider;
  const AudioController(
      {super.key,
      required this.audioPlayer,
      required this.url,
      required this.gyroProvider});

  @override
  State<AudioController> createState() => _AudioControllerState();
}

class _AudioControllerState extends State<AudioController> {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _isPlaying = false;
  bool _isPaused = false;
  bool _isOnRepeat = false;
  bool _isOn3DAudio = false;
  double _playbackRate = 1.0;
  double _balance = 0.0;
  Color? _repeatColor;
  Color? _3DAudioColor;
  final List<StreamSubscription> _streamSubscriptions = [];
  final List<IconData> _icons = [
    Icons.play_arrow,
    Icons.pause,
  ];

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(widget.audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    }));
    _streamSubscriptions.add(widget.audioPlayer.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    }));
    _streamSubscriptions
        .add(widget.audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        if (!_isOnRepeat) {
          _isPlaying = false;
          _isPaused = false;
          _position = Duration.zero;
        }
      });
    }));
    widget.audioPlayer.setSourceUrl(widget.url);

    widget.gyroProvider.addAccListener(_changeBalanceCallBack);
  }

  void _changeBalanceCallBack(List<double> acc) {
    // normalize acc to [-1, 1]
    double x = (acc[0] / 9.8) * -1;
    setState(() {
      _balance = _isOn3DAudio ? x : 0.0;
      widget.audioPlayer.setBalance(_balance);
    });
  }

  @override
  void dispose() {
    widget.gyroProvider.removeAccListener(_changeBalanceCallBack);
    for (var element in _streamSubscriptions) {
      element.cancel();
    }
    super.dispose();
  }

  Widget _btnStart() {
    return Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
      return IconButton(
        icon: Icon(_icons[_isPlaying ? 1 : 0],
            size: 30,
            color: getColorMap(settingsProvider.themeFlavor)["mauve"]),
        onPressed: () {
          if (_isPlaying) {
            widget.audioPlayer.pause();
            setState(() {
              _isPlaying = false;
              _isPaused = true;
            });
          } else {
            widget.audioPlayer.play(UrlSource(widget.url));
            setState(() {
              _isPlaying = true;
              _isPaused = false;
            });
          }
        },
      );
    });
  }

  Widget _bntFast() {
    return IconButton(
      icon: const Icon(Icons.fast_forward, size: 20),
      onPressed: () {
        setState(() {
          _playbackRate = 1.5;
        });
        widget.audioPlayer.setPlaybackRate(_playbackRate);
      },
    );
  }

  Widget _bntSlow() {
    return IconButton(
      icon: const Icon(Icons.fast_rewind, size: 20),
      onPressed: () {
        setState(() {
          _playbackRate = 0.5;
        });
        widget.audioPlayer.setPlaybackRate(_playbackRate);
      },
    );
  }

  Widget _btnRepeat() {
    return Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
      return IconButton(
        icon: Icon(Icons.repeat,
            size: 20,
            color: _repeatColor ??
                getColorMap(settingsProvider.themeFlavor)["text"]),
        onPressed: () {
          if (_isOnRepeat) {
            widget.audioPlayer.setReleaseMode(ReleaseMode.stop);
            setState(() {
              _isOnRepeat = false;
              _repeatColor = getColorMap(settingsProvider.themeFlavor)["text"];
            });
          } else {
            widget.audioPlayer.setReleaseMode(ReleaseMode.loop);
            setState(() {
              _isOnRepeat = true;
              _repeatColor = getColorMap(settingsProvider.themeFlavor)["mauve"];
            });
          }
        },
      );
    });
  }

  Widget _btnPlayBackRate() {
    return IconButton(
      icon: Text(
        _playbackRate.toString(),
        style: const TextStyle(fontSize: 15),
      ),
      onPressed: () {
        if (_playbackRate != 1.0) {
          widget.audioPlayer.setPlaybackRate(1.0);
          setState(() {
            _playbackRate = 1.0;
          });
        }
      },
    );
  }

  Widget _btn3DAudio() {
    return Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
      return IconButton(
        icon: Icon(Icons.audiotrack,
            size: 20,
            color: _3DAudioColor ??
                getColorMap(settingsProvider.themeFlavor)["text"]),
        onPressed: () {
          if (_isOn3DAudio) {
            widget.audioPlayer.setReleaseMode(ReleaseMode.stop);
            setState(() {
              _isOn3DAudio = false;
              _3DAudioColor = getColorMap(settingsProvider.themeFlavor)["text"];
            });
            widget.audioPlayer.setBalance(0.0);
          } else {
            widget.audioPlayer.setReleaseMode(ReleaseMode.loop);
            setState(() {
              _isOn3DAudio = true;
              _3DAudioColor =
                  getColorMap(settingsProvider.themeFlavor)["mauve"];
            });
          }
        },
      );
    });
  }

  Widget _slider() {
    return Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
      return Slider(
        activeColor: getColorMap(settingsProvider.themeFlavor)["red"],
        inactiveColor: getColorMap(settingsProvider.themeFlavor)["text"],
        value: _position.inSeconds.toDouble(),
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            changeToSecond(value.toInt());
            value = value;
          });
        },
      );
    });
  }

  void changeToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    widget.audioPlayer.seek(newDuration);
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
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _position.toString().split(".").first,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    _duration.toString().split(".").first,
                    style: const TextStyle(fontSize: 16),
                  ),
                ]),
          ),
          _slider(),
          _loadAsset(),
          Text(
            'Balance: ${_balance.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
