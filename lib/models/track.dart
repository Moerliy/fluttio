class Track {
  final String id;
  final String name;
  final int duration;
  final String artistName;
  final String albumName;
  final String licenseCcurl;
  final String releasedate;
  final String audio;
  final String image;

  // Constructor with optional named parameters and default values
  Track({
    required this.id,
    this.name = 'Unknown Title',
    this.duration = 0,
    this.artistName = 'Unknown Artist',
    this.albumName = 'Unknown Album',
    this.licenseCcurl = '',
    this.releasedate = '',
    this.audio = '',
    this.image = '',
  });

  // Factory constructor to create a Track object from a JSON map
  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unknown Title',
      duration: json['duration'] ?? 0,
      artistName: json['artist_name'] ?? 'Unknown Artist',
      albumName: json['album_name'] ?? 'Unknown Album',
      licenseCcurl: json['license_ccurl'] ?? '',
      releasedate: json['releasedate'] ?? '',
      audio: json['audio'] ?? '',
      image: json['image'] ?? '',
    );
  }

  // Method to convert Track object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'artist_name': artistName,
      'album_name': albumName,
      'license_ccurl': licenseCcurl,
      'releasedate': releasedate,
      'audio': audio,
      'image': image,
    };
  }
}
