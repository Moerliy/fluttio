import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:esense_flutter/esense.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroProvider with ChangeNotifier {
  List<double> _gyro = [0, 0, 0];
  List<double> _acc = [0, 0, 0];

  bool _useESense = false;

  // eSense device status
  String _deviceStatus = 'disconnected';
  bool _connected = false;
  late StreamSubscription _subscription;

  static Duration sensorInterval = const Duration(milliseconds: 100);
  static const String eSenseDeviceName = 'eSense-0390';
  final ESenseManager eSenseManager = ESenseManager(eSenseDeviceName);

  GyroProvider() {
    _useESense = false;
    _startListenToGyroSensorEventsDevice();
  }

  List<double> get gyro => _gyro;
  List<double> get acc => _acc;
  bool get useESense => _useESense;
  String get deviceStatus => _deviceStatus;
  bool get connected => _connected;

  @override
  void dispose() {
    _pauseListenToSensorEvents();
    eSenseManager.disconnect();
    super.dispose();
  }

  void toggleProvider() {
    _useESense = !_useESense;
    _subscription.cancel();
    if (_useESense) {
      // _listenToESense();

      // Loop for $TIMEOUT_SECONDS over connected
      // if connected start the listen
      // else use ESense = false

      // _startListenToGyroSensorEventsESense();
      _useESense = false;
      _startListenToGyroSensorEventsDevice();
    } else {
      _startListenToGyroSensorEventsDevice();
    }
  }

  Future<void> _askForPermissions() async {
    if (!(await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted)) {
      print(
          'WARNING - no permission to use Bluetooth granted. Cannot access eSense device.');
    }
    // for some strange reason, Android requires permission to location for Bluetooth to work.....?
    if (Platform.isAndroid) {
      if (!(await Permission.locationWhenInUse.request().isGranted)) {
        print(
            'WARNING - no permission to access location granted. Cannot access eSense device.');
      }
    }
  }

  Future<void> _listenToESense() async {
    await _askForPermissions();

    // if you want to get the connection events when connecting,
    // set up the listener BEFORE connecting...
    eSenseManager.connectionEvents.listen((event) {
      print('CONNECTION event: $event');

      // when we're connected to the eSense device, we can start listening to events from it
      if (event.type == ConnectionType.connected) _listenToESenseEvents();

      _connected = false;
      switch (event.type) {
        case ConnectionType.connected:
          _deviceStatus = 'connected';
          _connected = true;
          // _startListenToGyroSensorEvents();
          break;
        case ConnectionType.unknown:
          _deviceStatus = 'unknown';
          break;
        case ConnectionType.disconnected:
          _deviceStatus = 'disconnected';
          _pauseListenToSensorEvents();
          break;
        case ConnectionType.device_found:
          _deviceStatus = 'device_found';
          break;
        case ConnectionType.device_not_found:
          _deviceStatus = 'device_not_found';
          break;
      }
    });
  }

  Future<void> connectToESense() async {
    if (!connected) {
      print('Trying to connect to eSense device...');
      _connected = await eSenseManager.connect();

      _deviceStatus = connected ? 'connecting...' : 'connection failed';
    }
  }

  Future<void> disconnectFromESense() async {
    if (connected) {
      print('Trying to disconnect from eSense device...');
      _pauseListenToSensorEvents();
      _connected = await eSenseManager.disconnect();

      _deviceStatus = connected ? 'disconnected' : 'disconnecting...';
    }
  }

  void _listenToESenseEvents() async {
    eSenseManager.eSenseEvents.listen((event) {
      print('ESENSE event: $event');
    });

    _getESenseProperties();
  }

  void _getESenseProperties() async {
    Timer(const Duration(seconds: 2),
        () async => await eSenseManager.getAccelerometerOffset());
  }

  void _startListenToGyroSensorEventsESense() async {
    // any changes to the sampling frequency must be done BEFORE listening to sensor events
    double samplingRateHZ = 1000.0 / sensorInterval.inMilliseconds;
    print('setting sampling frequency to $samplingRateHZ Hz');
    await eSenseManager.setSamplingRate(samplingRateHZ.round());

    _subscription = eSenseManager.sensorEvents.listen((event) {
      // only update state, if the event contains valid data
      if (event.gyro != null && event.accel != null) {
        var eSenseGyro = [event.gyro![0], event.gyro![1], event.gyro![2]]
            .map((e) => (e / 131)) // value divided by gyro scale factor
            .toList();

        var eSenseAcc = [event.accel![0], event.accel![1], event.accel![2]]
            .map((e) =>
                (e / 8192) * 9.80665) // value divided by accel scale factor * g
            .toList();

        // re-orient to match device orientation
        _gyro = [
          eSenseGyro[2] * (-1),
          eSenseGyro[1] * (-1),
          eSenseGyro[0] * (-1)
        ];
        _acc = [eSenseAcc[2] * (-1), eSenseAcc[1] * (-1), eSenseAcc[0] * (-1)];
        notifyListeners();
      }
    });
  }

  _startListenToGyroSensorEventsDevice() async {
    _subscription = gyroscopeEventStream().listen((GyroscopeEvent event) {
      _gyro = [event.x, event.y, event.z].map((e) => e * (180 / pi)).toList();
      _acc = [event.x, event.y, event.z];
      notifyListeners();
    });
  }

  void _pauseListenToSensorEvents() async {
    _subscription.cancel();
  }
}
