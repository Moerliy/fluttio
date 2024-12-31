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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _words = [];

  @override
  void initState() {
    super.initState();
    _fetchTracks();
  }

  void _fetchTracks() {
    fetchTracks(clientId, fuzzytags: _words, limit: 30).then((tracks) {
      setState(() {
        _tracks = tracks;
      });
    });
  }

  void _onTextChanged(String text) {
    // Split the input text into words based on spaces.
    setState(() {
      _words =
          text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailAudioPage(
                    borderColor:
                        getColorMap(settingsProvider.themeFlavor)["base"] ??
                            Colors.white,
                    track: track),
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
    return Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: true,
              title: const Text('Select Music'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: getColorMap(settingsProvider.themeFlavor)["text"]),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              bottom: AppBar(
                title: Stack(
                  children: [
                    // Background for words.
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 12.0), // Match TextField padding.
                          child: RichText(
                            text: TextSpan(
                              children: _words
                                  .map((word) => WidgetSpan(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 4.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 1.0, vertical: 2.0),
                                          decoration: BoxDecoration(
                                            color: getColorMap(settingsProvider
                                                .themeFlavor)["mauve"],
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          child: Text(
                                            word,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: getColorMap(
                                                  settingsProvider
                                                      .themeFlavor)["base"],
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Input field.
                    TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Search Tag...',
                        hintStyle: TextStyle(
                            color: getColorMap(
                                settingsProvider.themeFlavor)["overlay0"]),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0), // Match RichText padding.
                      ),
                      style: const TextStyle(
                        color: Colors.transparent, // Transparent text.
                        fontSize: 16.0,
                        height: 1.5, // Line height matches RichText.
                      ),
                      cursorColor: getColorMap(settingsProvider.themeFlavor)[
                          "text"], // Visible cursor.
                      onChanged: _onTextChanged,
                      onSubmitted: (query) {
                        _fetchTracks();
                      },
                    ),
                  ],
                ),
                leading: IconButton(
                  icon: Icon(Icons.search,
                      color: getColorMap(settingsProvider.themeFlavor)["text"]),
                  onPressed: () {
                    _fetchTracks();
                  },
                ),
              ),
            ),
            _tracks == null
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _trackSkeleton(),
                      childCount: 10, // Number of placeholder items
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final track = _tracks![index];
                        return _track(track);
                      },
                      childCount: _tracks!.length,
                    ),
                  ),
          ],
        ),
      );
    });
  }
}
