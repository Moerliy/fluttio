import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttio/providers/gyro_provider.dart';

class AudioController extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final GyroProvider gyroProvider;
  const AudioController(
      {super.key, required this.audioPlayer, required this.gyroProvider});

  @override
  State<AudioController> createState() => _AudioControllerState();
}

class _AudioControllerState extends State<AudioController> {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _isPlaying = false;
  bool _isPaused = false;
  bool _isOnRepeat = false;
  double _playbackRate = 1.0;
  double _balance = 0.0;
  Color _repeatColor = Colors.black;
  final List<IconData> _icons = [
    Icons.play_arrow,
    Icons.pause,
  ];
  final String url =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  @override
  void initState() {
    super.initState();
    widget.audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });
    widget.audioPlayer.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });
    widget.audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        if (!_isOnRepeat) {
          _isPlaying = false;
          _isPaused = false;
          _position = Duration.zero;
        }
      });
    });
    widget.audioPlayer.setSourceUrl(url);

    widget.gyroProvider.addAccListener((List<double> acc) {
      // normalize acc to [-1, 1]
      double x = (acc[0] / 9.8) * -1;
      setState(() {
        _balance = x;
        widget.audioPlayer.setBalance(_balance);
      });
    });
  }

  Widget _btnStart() {
    return IconButton(
      icon: Icon(_icons[_isPlaying ? 1 : 0], size: 30, color: Colors.blue),
      onPressed: () {
        if (_isPlaying) {
          widget.audioPlayer.pause();
          setState(() {
            _isPlaying = false;
            _isPaused = true;
          });
        } else {
          widget.audioPlayer.play(UrlSource(url));
          setState(() {
            _isPlaying = true;
            _isPaused = false;
          });
        }
      },
    );
  }

  Widget _bntFast() {
    return IconButton(
      icon: const Icon(Icons.fast_forward, size: 20, color: Colors.black),
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
      icon: const Icon(Icons.fast_rewind, size: 20, color: Colors.black),
      onPressed: () {
        setState(() {
          _playbackRate = 0.5;
        });
        widget.audioPlayer.setPlaybackRate(_playbackRate);
      },
    );
  }

  Widget _btnRepeat() {
    return IconButton(
      icon: Icon(Icons.repeat, size: 20, color: _repeatColor),
      onPressed: () {
        if (_isOnRepeat) {
          widget.audioPlayer.setReleaseMode(ReleaseMode.stop);
          setState(() {
            _isOnRepeat = false;
            _repeatColor = Colors.black;
          });
        } else {
          widget.audioPlayer.setReleaseMode(ReleaseMode.loop);
          setState(() {
            _isOnRepeat = true;
            _repeatColor = Colors.blue;
          });
        }
      },
    );
  }

  Widget _btnPlayBackRate() {
    return IconButton(
      icon: Text(
        _playbackRate.toString(),
        style: const TextStyle(fontSize: 15, color: Colors.black),
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

  Widget _slider() {
    return Slider(
      activeColor: Colors.red,
      inactiveColor: Colors.grey,
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
