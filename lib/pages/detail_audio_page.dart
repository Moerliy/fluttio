import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttio/audio_controller.dart';
import 'package:fluttio/models/theme.dart';
import 'package:fluttio/providers/gyro_provider.dart';
import 'package:fluttio/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class DetailAudioPage extends StatefulWidget {
  final Color borderColor;
  const DetailAudioPage({super.key, required this.borderColor});

  @override
  State<DetailAudioPage> createState() => _DetailAudioPageState();
}

class _DetailAudioPageState extends State<DetailAudioPage> {
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<GyroProvider, SettingsProvider>(
        builder: (context, gyroProvider, settingsProvider, child) {
      return Scaffold(
        backgroundColor: getColorMap(settingsProvider.themeFlavor)["base"],
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: screenHeight * 0.5,
              child: Container(
                color: getColorMap(settingsProvider.themeFlavor)["mauve"],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: getColorMap(
                          settingsProvider.themeFlavor)["surface0"]),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                top: screenHeight * 0.2,
                height: screenHeight * 0.36,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color:
                        getColorMap(settingsProvider.themeFlavor)["surface2"],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      const Text('Audio Title',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      const Text('Audio Artist',
                          style: TextStyle(fontSize: 20)),
                      AudioController(
                        audioPlayer: audioPlayer,
                        gyroProvider: gyroProvider,
                      ),
                    ],
                  ),
                )),
            Positioned(
              left: (screenWidth - 150) / 2,
              right: (screenWidth - 150) / 2,
              top: screenHeight * 0.12,
              height: screenHeight * 0.16,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  // shape: BoxShape.circle,
                  border: Border.all(color: widget.borderColor, width: 2),
                  color: getColorMap(settingsProvider.themeFlavor)["overlay1"],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: widget.borderColor, width: 5),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/test_audio_cover.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
