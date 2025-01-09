import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttio/audio_controller.dart';
import 'package:fluttio/communication_manager.dart';
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
  final String clientId = "c4a2c85b";
  List<Track>? _similarTracks; // Store fetched track list.

  @override
  void initState() {
    super.initState();
    _fetchTracks();
  }

  void _fetchTracks() {
    fetchSimilarTracks(clientId, widget.track.id, limit: 20).then((tracks) {
      setState(() {
        _similarTracks = tracks;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _track(Track track) {
    return Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: getColorMap(settingsProvider.themeFlavor)["overlay0"],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DetailAudioPage(track: track),
              ),
            );
          },
          title: Text(
            track.name,
            style: const TextStyle(fontSize: 16.0),
          ),
          subtitle: Text(
            track.artistName,
            style: const TextStyle(fontSize: 14.0),
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(track.image),
          ),
          trailing: Text(
            formatDuration(track.duration),
            style: const TextStyle(fontSize: 14.0),
          ),
        ),
      );
    });
  }

  Widget _trackSkeleton() {
    return Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: getColorMap(settingsProvider.themeFlavor)["surface2"],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          // onTap: () {
          // },
          title: Text(
            "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒",
            style: TextStyle(
                fontSize: 16.0,
                color: getColorMap(settingsProvider.themeFlavor)["subtext1"]),
          ),
          subtitle: Text(
            "░░░░░░░░░░░░",
            style: TextStyle(
                fontSize: 14.0,
                color: getColorMap(settingsProvider.themeFlavor)["subtext1"]),
          ),
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/covor-place-holder.jpg'),
          ),
          trailing: Text(
            "░░░",
            style: TextStyle(
                fontSize: 14.0,
                color: getColorMap(settingsProvider.themeFlavor)["subtext1"]),
          ),
        ),
      );
    });
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
              top: screenHeight * 0.145 + screenHeight * 0.36,
              left: 0,
              right: 0,
              height:
                  screenHeight - (screenHeight * 0.145 + screenHeight * 0.36),
              child: Container(
                color: getColorMap(settingsProvider.themeFlavor)["base"],
                child: _similarTracks == null
                    ? ListView.builder(
                        itemCount: 10, // Number of placeholder items
                        itemBuilder: (context, index) => _trackSkeleton(),
                      )
                    : ListView.builder(
                        itemCount: _similarTracks!.length,
                        itemBuilder: (context, index) {
                          final track = _similarTracks![index];
                          return _track(track);
                        },
                      ),
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
                        track: widget.track,
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
