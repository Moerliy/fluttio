import 'package:flutter/material.dart';
import 'package:fluttio/providers/gyro_provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device & eSense Sensor Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(21.0), // Add padding
        child: Consumer<GyroProvider>(
          builder: (context, prov, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Gyro:'),
                Text('  X: ${prov.gyro[0].toStringAsFixed(fractionalDigits)}'),
                Text('  Y: ${prov.gyro[1].toStringAsFixed(fractionalDigits)}'),
                Text('  Z: ${prov.gyro[2].toStringAsFixed(fractionalDigits)}'),
                const SizedBox(height: 10),
                const Text('Accel:'),
                Text('  X: ${prov.acc[0].toStringAsFixed(fractionalDigits)}'),
                Text('  Y: ${prov.acc[1].toStringAsFixed(fractionalDigits)}'),
                Text('  Z: ${prov.acc[2].toStringAsFixed(fractionalDigits)}'),
                Text('Device Status: ${prov.deviceStatus}'),
              ],
            );
          },
        ),
      ),
    );
  }
}
