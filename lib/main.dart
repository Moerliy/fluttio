import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttio/providers/gyro_provider.dart';
import 'package:provider/provider.dart';

void main() {
  // this forces the orientation to be portrait and locks it
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
    (_) => runApp(const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GyroProvider _gyroProvider = GyroProvider();

  // number of fractional digits to display
  static const int fractionalDigits = 2;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _gyroProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => _gyroProvider),
        ],
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Device & eSense Sensor Test'),
            ),
            body: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(21.0), // Add padding
                child: ListView(
                  children: [
                    Consumer<GyroProvider>(
                      builder: (context, prov, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Gyro:'),
                            Text(
                                '  X: ${prov.gyro[0].toStringAsFixed(fractionalDigits)}'),
                            Text(
                                '  Y: ${prov.gyro[1].toStringAsFixed(fractionalDigits)}'),
                            Text(
                                '  Z: ${prov.gyro[2].toStringAsFixed(fractionalDigits)}'),
                            SizedBox(height: 10),
                            Text('Accel:'),
                            Text(
                                '  X: ${prov.acc[0].toStringAsFixed(fractionalDigits)}'),
                            Text(
                                '  Y: ${prov.acc[1].toStringAsFixed(fractionalDigits)}'),
                            Text(
                                '  Z: ${prov.acc[2].toStringAsFixed(fractionalDigits)}'),
                            Text('Device Status: ${prov.deviceStatus}'),
                            // Container(
                            //   height: 80,
                            //   width: 200,
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(10),
                            //       border: Border.all(
                            //           color: (!prov.connected)
                            //               ? Colors.blueAccent
                            //               : Colors.redAccent)),
                            //   child: TextButton.icon(
                            //     onPressed: (!prov.connected)
                            //         ? prov.connectToESense
                            //         : prov.disconnectFromESense,
                            //     icon: Icon(
                            //       (!prov.connected)
                            //           ? Icons.login
                            //           : Icons.logout,
                            //     ),
                            //     label: Text(
                            //       (!prov.connected)
                            //           ? 'Connect eSense'
                            //           : 'Disconnect eSense',
                            //       style: const TextStyle(fontSize: 20),
                            //     ),
                            //   ),
                            // ),
                            ElevatedButton(
                              onPressed: prov.toggleProvider,
                              child: Text(prov.useESense
                                  ? 'Switch to Device Gyro'
                                  : 'Switch to eSense Gyro'),
                            ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
