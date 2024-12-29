import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttio/models/theme.dart';
import 'package:fluttio/pages/detail_audio_page.dart';
import 'package:fluttio/pages/settings_page.dart';
import 'package:fluttio/pages/test_page.dart';
import 'package:fluttio/providers/gyro_provider.dart';
import 'package:fluttio/pages/device_esense_test_page.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:fluttio/providers/settings_provider.dart';
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
    final width = MediaQuery.of(context).size.width;
    final buttonWidth = width * 0.6;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => _gyroProvider),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: OverlaySupport.global(
        child: Consumer<SettingsProvider>(
          builder: (context, settingsProvider, child) {
            return MaterialApp(
              theme: catppuccinTheme(settingsProvider.themeFlavor),
              home: Scaffold(
                body: Center(
                  child: Builder(
                    builder: (context) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Fluttio',
                            style: TextStyle(
                              fontSize: 50.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'by Moritz Gleissner',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const Text(
                            '<ughlu>',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: buttonWidth,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailAudioPage(
                                        borderColor: getColorMap(
                                                settingsProvider
                                                    .themeFlavor)["base"] ??
                                            Colors.white),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 30.0),
                                backgroundColor: getColorMap(
                                    settingsProvider.themeFlavor)["overlay0"],
                                foregroundColor: getColorMap(
                                    settingsProvider.themeFlavor)["text"],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text(
                                'Listen To Music',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: buttonWidth,
                            child: TextButton(
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
                                backgroundColor: getColorMap(
                                    settingsProvider.themeFlavor)["overlay0"],
                                foregroundColor: getColorMap(
                                    settingsProvider.themeFlavor)["text"],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text(
                                'Device & eSense Test',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: buttonWidth,
                            child: TextButton(
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
                                backgroundColor: getColorMap(
                                    settingsProvider.themeFlavor)["overlay0"],
                                foregroundColor: getColorMap(
                                    settingsProvider.themeFlavor)["text"],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text(
                                'Settings',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
