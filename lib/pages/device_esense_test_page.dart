import 'package:flutter/material.dart';
import 'package:fluttio/models/theme.dart';
import 'package:fluttio/providers/gyro_provider.dart';
import 'package:fluttio/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class DeviceEsenseTestPage extends StatefulWidget {
  const DeviceEsenseTestPage({super.key});

  @override
  State<DeviceEsenseTestPage> createState() => _DeviceEsenseTestPageState();
}

class _DeviceEsenseTestPageState extends State<DeviceEsenseTestPage> {
  // number of fractional digits to display
  static const int fractionalDigits = 2;

  @override
  Widget build(BuildContext context) {
    return Consumer2<GyroProvider, SettingsProvider>(
        builder: (context, gyroProvider, settingsProvider, child) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Device & eSense Sensor Test'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: getColorMap(settingsProvider.themeFlavor)["text"]),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Padding(
              padding: const EdgeInsets.all(21.0), // Add padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Gyro:'),
                  Text(
                      '  X: ${gyroProvider.gyro[0].toStringAsFixed(fractionalDigits)}'),
                  Text(
                      '  Y: ${gyroProvider.gyro[1].toStringAsFixed(fractionalDigits)}'),
                  Text(
                      '  Z: ${gyroProvider.gyro[2].toStringAsFixed(fractionalDigits)}'),
                  const SizedBox(height: 10),
                  const Text('Accel:'),
                  Text(
                      '  X: ${gyroProvider.acc[0].toStringAsFixed(fractionalDigits)}'),
                  Text(
                      '  Y: ${gyroProvider.acc[1].toStringAsFixed(fractionalDigits)}'),
                  Text(
                      '  Z: ${gyroProvider.acc[2].toStringAsFixed(fractionalDigits)}'),
                  Text('Device Status: ${gyroProvider.deviceStatus}'),
                ],
              )));
    });
  }
}
