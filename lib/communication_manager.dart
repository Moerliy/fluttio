import 'dart:convert';
import 'package:fluttio/models/track.dart';
import 'package:http/http.dart' as http;

String toFuzzyTags(List<String> tags) {
  return tags.join('+');
}

Future<List<Track>> fetchTracks(String clientId,
    {List<String> fuzzytags = const [], int limit = 1}) async {
  final url =
      'https://api.jamendo.com/v3.0/tracks?client_id=$clientId&format=json&limit=$limit&fuzzytags=${toFuzzyTags(fuzzytags)}';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['results'] != null && data['results'].isNotEmpty) {
      return data['results']
          .map<Track>(
              (json) => Track.fromJson(json)) // Convert each JSON to a Track.
          .toList();
    }
    throw Exception('No tracks found');
  } else {
    throw Exception('Failed to fetch tracks');
  }
}

Future<List<Track>> fetchSimilarTracks(String clientId, String trackId,
    {int limit = 1}) async {
  final url =
      'https://api.jamendo.com/v3.0/tracks/similar?client_id=$clientId&id=$trackId&format=json&limit=$limit}';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['results'] != null && data['results'].isNotEmpty) {
      return data['results']
          .map<Track>(
              (json) => Track.fromJson(json)) // Convert each JSON to a Track.
          .toList();
    } else {
      return await fetchTracks(clientId, limit: limit).then((tracks) {
        return tracks;
      });
    }
  } else {
    throw Exception('Failed to fetch tracks');
  }
}
