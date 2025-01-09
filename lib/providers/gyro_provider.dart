import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter/material.dart';
import 'package:esense_flutter/esense.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttio/models/Notification.dart';
import 'package:fluttio/models/theme.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroProvider with ChangeNotifier {
  List<double> _gyro = [0, 0, 0];
  List<double> _acc = [0, 0, 0];

  // fonctions to exec when _acc changes
  final List<Function(List<double>)> _accListeners = [];

  bool _useESense = false;
  bool _switching = false;

  // eSense device status
  String _deviceStatus = 'disconnected';
  bool _connected = false;
  final List<StreamSubscription> _subscriptions = [];

  static Duration sensorInterval = const Duration(milliseconds: 100);
  static const Duration timeoutSecounds = Duration(seconds: 5);
  static const Duration conectionCheckRate = Duration(milliseconds: 100);
  static const String eSenseDeviceName = 'eSense-0390';
  final ESenseManager eSenseManager = ESenseManager(eSenseDeviceName);
  final List<NotificationEntry> _notificationQueue = [];
  bool _isNotificationShowing = false;

  GyroProvider() {
    _useESense = false;
    _startListenToGyroSensorEventsDevice();
  }

  List<double> get gyro => _gyro;
  List<double> get acc => _acc;
  bool get useESense => _useESense;
  bool get switching => _switching;
  String get deviceStatus => _deviceStatus;
  bool get connected => _connected;

  set acc(List<double> value) {
    _acc = value;
    for (var element in _accListeners) {
      element(value);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _pauseListenToSensorEvents();
    eSenseManager.disconnect();
    super.dispose();
  }

  void addAccListener(Function(List<double>) listener) {
    _accListeners.add(listener);
  }

  void removeAccListener(Function(List<double>) listener) {
    _accListeners.remove(listener);
  }

  void _showNextNotification() {
    if (_notificationQueue.isNotEmpty && !_isNotificationShowing) {
      _isNotificationShowing = true;
      final entry = _notificationQueue.removeAt(0);
      showSimpleNotification(
        entry.text,
        leading: entry.icon,
        background: entry.background,
        autoDismiss: true,
        slideDismissDirection: DismissDirection.up,
        duration: const Duration(seconds: 3),
      ).dismissed.then((_) {
        _isNotificationShowing = false;
        _showNextNotification();
      });
    }
  }

  void _enqueueNotification(Text text, Icon icon, Color? background) {
    _notificationQueue.add(NotificationEntry(text, icon, background));
    _showNextNotification();
  }

  Future<void> toggleProvider(Flavor flavor) async {
    _switching = true;
    _useESense = !_useESense;
    if (_useESense) {
      await connectToESense();
      _listenToESense();

      var elapsed = Duration.zero;
      Timer.periodic(conectionCheckRate, (timer) {
        if (elapsed >= timeoutSecounds) {
          timer.cancel();

          _useESense = false;
          for (var element in _subscriptions) {
            element.cancel();
          }
          _subscriptions.clear();
          _startListenToGyroSensorEventsDevice();
          _enqueueNotification(
              Text(
                "Failed to connect to eSense device. Using device sensor",
                style: TextStyle(color: getColorMap(flavor)["surface0"]),
              ),
              Icon(Icons.notifications, color: getColorMap(flavor)["surface0"]),
              getColorMap(flavor)["red"]);
          _switching = false;
          notifyListeners();
        } else {
          elapsed += conectionCheckRate;
          if (connected) {
            timer.cancel();

            for (var element in _subscriptions) {
              element.cancel();
            }
            _subscriptions.clear();
            _startListenToGyroSensorEventsESense();
            _enqueueNotification(
                Text(
                  "Connected to eSense device",
                  style: TextStyle(color: getColorMap(flavor)["surface0"]),
                ),
                Icon(Icons.notifications,
                    color: getColorMap(flavor)["surface0"]),
                getColorMap(flavor)["green"]);
            _bluetoothESenseConnected(flavor);
            _switching = false;
          }
          notifyListeners();
        }
      });
    } else {
      for (var element in _subscriptions) {
        element.cancel();
      }
      _subscriptions.clear();
      _startListenToGyroSensorEventsDevice();
      _enqueueNotification(
          Text(
            "Using device sensor",
            style: TextStyle(color: getColorMap(flavor)["surface0"]),
          ),
          Icon(Icons.notifications, color: getColorMap(flavor)["surface0"]),
          getColorMap(flavor)["blue"]);
      _switching = false;
      notifyListeners();
    }
  }

  void _bluetoothESenseConnected(Flavor flavor) {
    if (Platform.isAndroid) {
      FlutterBluetoothSerial.instance
          .getBondedDevices()
          .then((List<BluetoothDevice> devices) {
        BluetoothDevice? device;
        try {
          device = devices.firstWhere(
            (BluetoothDevice device) => device.name == eSenseDeviceName,
          );
        } on StateError {
          _enqueueNotification(
              Text(
                "Connect to ESense via bluetooth with name $eSenseDeviceName for better experience",
                style: TextStyle(color: getColorMap(flavor)["surface0"]),
              ),
              Icon(Icons.notifications, color: getColorMap(flavor)["surface0"]),
              getColorMap(flavor)["yellow"]);
          return;
        }

        if (!device.isConnected) {
          showSimpleNotification(
              Text(
                "Connect to ESense via bluetooth with name $eSenseDeviceName for better experience",
                style: TextStyle(color: getColorMap(flavor)["surface0"]),
              ),
              leading: Icon(Icons.notifications,
                  color: getColorMap(flavor)["surface0"]),
              background: getColorMap(flavor)["yellow"]);
        }
      });
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
    // if you want to get the connection events when connecting,
    // set up the listener BEFORE connecting...
    eSenseManager.connectionEvents.listen((event) {
      print('CONNECTION event: $event');

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
      notifyListeners();
    });
  }

  Future<void> connectToESense() async {
    if (!connected) {
      print('Trying to connect to eSense device...');
      _connected = await eSenseManager.connect();

      _deviceStatus = connected ? 'connecting...' : 'connection failed';
      notifyListeners();
    }
  }

  Future<void> disconnectFromESense() async {
    if (connected) {
      print('Trying to disconnect from eSense device...');
      _pauseListenToSensorEvents();
      _connected = await eSenseManager.disconnect();

      _deviceStatus = connected ? 'disconnected' : 'disconnecting...';
      notifyListeners();
    }
  }

  void _startListenToGyroSensorEventsESense() async {
    // any changes to the sampling frequency must be done BEFORE listening to sensor events
    double samplingRateHZ = 1000.0 / sensorInterval.inMilliseconds;
    await eSenseManager.setSamplingRate(samplingRateHZ.round());

    var subscription = eSenseManager.sensorEvents.listen((event) {
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
        acc = [eSenseAcc[2] * (-1), eSenseAcc[1] * (-1), eSenseAcc[0] * (-1)];
        notifyListeners();
      }
    });
    _subscriptions.add(subscription);
  }

  _startListenToGyroSensorEventsDevice() async {
    var subscription = gyroscopeEventStream().listen((GyroscopeEvent event) {
      _gyro = [event.x, event.y, event.z].map((e) => e * (180 / pi)).toList();
      notifyListeners();
    });
    var subscription2 =
        accelerometerEventStream().listen((AccelerometerEvent event) {
      acc = [event.x, event.y, event.z];
      notifyListeners();
    });
    _subscriptions.add(subscription);
    _subscriptions.add(subscription2);
  }

  void _pauseListenToSensorEvents() async {
    for (var element in _subscriptions) {
      element.cancel();
    }
    _subscriptions.clear();
  }
}
