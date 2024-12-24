import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttio/pages/settings_page.dart';
import 'package:fluttio/providers/gyro_provider.dart';
import 'package:fluttio/pages/device_esense_test_page.dart';
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
              title: const Text('Main View'),
            ),
            body: Center(
              child: Builder(
                builder: (context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
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
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DeviceEsenseTestPage(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 30.0),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Device & eSense Test',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        )));
  }
}
