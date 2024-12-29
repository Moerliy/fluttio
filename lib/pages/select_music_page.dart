import 'package:flutter/material.dart';
import 'package:fluttio/communication_manager.dart';
import 'package:fluttio/models/track.dart';

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
                    title: Text(track.name),
                  ),
              ],
            ),
    );
  }
}
