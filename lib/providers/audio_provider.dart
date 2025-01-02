import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttio/providers/gyro_provider.dart';

class AudioProvider extends ChangeNotifier {
  final GyroProvider _gyroProvider;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _isPlaying = false;
  bool _isOnRepeat = false;
  bool _isOn3DAudio = false;
  double _playbackRate = 1.0;
  double _balance = 0.0;
  String? _currentPlayingUrl;
  final List<StreamSubscription> _streamSubscriptions = [];

  AudioProvider(this._gyroProvider) {
    _subscribeToAudioPlayer();
    _gyroProvider.addAccListener(_changeBalanceCallBack);
  }

  Duration get duration => _duration;
  Duration get position => _position;
  bool get isPlaying => _isPlaying;
  bool get isOnRepeat => _isOnRepeat;
  bool get isOn3DAudio => _isOn3DAudio;
  double get playbackRate => _playbackRate;
  double get balance => _balance;
  bool get hasSource => _audioPlayer.source != null;
  String? get currentPlayingUrl => _currentPlayingUrl;

  void pause() {
    _isPlaying = false;
    notifyListeners();
    _audioPlayer.pause();
  }

  void play({String? url}) {
    _isPlaying = true;
    if (url == null) {
      _audioPlayer.resume();
    } else {
      _audioPlayer.play(UrlSource(url));
      _currentPlayingUrl = url;
    }
    notifyListeners();
  }

  void playNoNotify({String? url}) {
    _isPlaying = true;
    if (url == null) {
      _audioPlayer.resume();
    } else {
      _audioPlayer.play(UrlSource(url));
      _currentPlayingUrl = url;
    }
  }

  void repeat() {
    _isOnRepeat = true;
    notifyListeners();
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void stopRepeat() {
    _isOnRepeat = false;
    notifyListeners();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  void setIsOn3DAudio(bool newVal) {
    _isOn3DAudio = newVal;
    if (_isOn3DAudio == false) {
      _balance = 0.0;
    }
    notifyListeners();
  }

  void setAudioPosition(Duration newPos) {
    _audioPlayer.seek(newPos);
  }

  void setPlaybackRate(double newVal) {
    _playbackRate = newVal;
    _audioPlayer.setPlaybackRate(_playbackRate);
    notifyListeners();
  }

  void _subscribeToAudioPlayer() {
    _streamSubscriptions.add(_audioPlayer.onDurationChanged.listen((d) {
      _duration = d;
      notifyListeners();
    }));
    _streamSubscriptions.add(_audioPlayer.onPositionChanged.listen((p) {
      _position = p;
      notifyListeners();
    }));
    _streamSubscriptions.add(_audioPlayer.onPlayerComplete.listen((event) {
      if (!_isOnRepeat) {
        _isPlaying = false;
        _position = Duration.zero;
        notifyListeners();
      }
    }));
  }

  void _changeBalanceCallBack(List<double> acc) {
    // normalize acc to [-1, 1]
    double x = (acc[0] / 9.8) * -1;
    _balance = _isOn3DAudio ? x : 0.0;
    notifyListeners();
    _audioPlayer.setBalance(_balance);
  }

  void unregisterAudioPlayer() {
    _gyroProvider.removeAccListener(_changeBalanceCallBack);
    for (var element in _streamSubscriptions) {
      element.cancel();
    }
  }

  void setNewTrack(String url) {
    _audioPlayer.setSourceUrl(url);
    _currentPlayingUrl = url;
    notifyListeners();
  }
}
