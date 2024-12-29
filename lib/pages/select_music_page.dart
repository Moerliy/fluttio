import 'package:flutter/material.dart';
import 'package:fluttio/communication_manager.dart';
import 'package:fluttio/models/theme.dart';
import 'package:fluttio/models/track.dart';
import 'package:fluttio/pages/detail_audio_page.dart';
import 'package:fluttio/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class SelectMusicPage extends StatefulWidget {
  const SelectMusicPage({super.key});

  @override
  State<SelectMusicPage> createState() => _SelectMusicPageState();
}

class _SelectMusicPageState extends State<SelectMusicPage> {
  final String clientId = "c4a2c85b";
  List<Track>? _tracks; // Store fetched track list.

  @override
  void initState() {
    super.initState();
    fetchTracks(clientId, limit: 10).then((tracks) {
      setState(() {
        _tracks = tracks;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // show names of all tracks

    return Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Select Music'),
        ),
        body: _tracks == null
            ? ListView.builder(
                itemCount: 10, // Number of placeholder items
                itemBuilder: (context, index) => const ListTile(
                  title: Text('Loading...'),
                ),
              )
            : ListView(
                children: [
                  for (final track in _tracks!)
                    ListTile(
                      title: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailAudioPage(
                                  borderColor:
                                      getColorMap(settingsProvider.themeFlavor)[
                                              "base"] ??
                                          Colors.white,
                                  track: track),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 30.0),
                          backgroundColor: getColorMap(
                              settingsProvider.themeFlavor)["overlay0"],
                          foregroundColor:
                              getColorMap(settingsProvider.themeFlavor)["text"],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          track.name,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                ],
              ),
      );
    });
  }
}
