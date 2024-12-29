import 'dart:convert';
import 'package:fluttio/models/track.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<List<Track>> fetchTracks(String clientId, {int limit = 1}) async {
  final url =
      'https://api.jamendo.com/v3.0/tracks?client_id=$clientId&format=json&limit=$limit';
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

Future<Image> fetchImage(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return Image.memory(response.bodyBytes);
  } else {
    throw Exception('Failed to fetch image');
  }
}
