import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttio/audio_controller.dart';
import 'package:fluttio/models/theme.dart';
import 'package:fluttio/models/track.dart';
import 'package:fluttio/providers/audio_provider.dart';
import 'package:fluttio/providers/gyro_provider.dart';
import 'package:fluttio/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class DetailAudioPage extends StatefulWidget {
  final Track track;
  const DetailAudioPage({super.key, required this.track});

  @override
  State<DetailAudioPage> createState() => _DetailAudioPageState();
}

class _DetailAudioPageState extends State<DetailAudioPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Consumer3<GyroProvider, SettingsProvider, AudioProvider>(builder:
        (context, gyroProvider, settingsProvider, audioProvider, child) {
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
                      Text(
                        widget.track.name,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        widget.track.artistName,
                        style: const TextStyle(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      AudioController(
                        url: widget.track.audio,
                        audioProvider: audioProvider,
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
                  border: Border.all(
                      color:
                          getColorMap(settingsProvider.themeFlavor)["base"] ??
                              Colors.white,
                      width: 2),
                  color: getColorMap(settingsProvider.themeFlavor)["overlay1"],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: getColorMap(
                                  settingsProvider.themeFlavor)["base"] ??
                              Colors.white,
                          width: 5),
                      image: DecorationImage(
                        image: NetworkImage(widget.track.image),
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
