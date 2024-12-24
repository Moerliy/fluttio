import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttio/pages/settings_page.dart';
import 'package:fluttio/providers/gyro_provider.dart';
import 'package:overlay_support/overlay_support.dart';
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
  late final GyroProvider _gyroProvider = GyroProvider();

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
        child: OverlaySupport.global(
            child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Device & eSense Sensor Test'),
            ),
            body: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(21.0), // Add padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<GyroProvider>(
                      builder: (context, prov, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Gyro:'),
                            Text(
                                '  X: ${prov.gyro[0].toStringAsFixed(fractionalDigits)}'),
                            Text(
                                '  Y: ${prov.gyro[1].toStringAsFixed(fractionalDigits)}'),
                            Text(
                                '  Z: ${prov.gyro[2].toStringAsFixed(fractionalDigits)}'),
                            const SizedBox(height: 10),
                            const Text('Accel:'),
                            Text(
                                '  X: ${prov.acc[0].toStringAsFixed(fractionalDigits)}'),
                            Text(
                                '  Y: ${prov.acc[1].toStringAsFixed(fractionalDigits)}'),
                            Text(
                                '  Z: ${prov.acc[2].toStringAsFixed(fractionalDigits)}'),
                            Text('Device Status: ${prov.deviceStatus}'),
                          ],
                        );
                      },
                    ),
                    const Spacer(),
                    Center(
                      child: Builder(
                        builder: (context) {
                          return TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsPage(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 30.0),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'Settings',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )));
  }
}
