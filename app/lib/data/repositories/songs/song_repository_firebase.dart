import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/artists/artist.dart';
import '../../../model/songs/song.dart';
import '../../dtos/artist_dto.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  static const String _host =
      'week-8-practice-265f7-default-rtdb.asia-southeast1.firebasedatabase.app';

  final Uri songsUri = Uri.https(
    _host,
    '/songs.json',
  );

  final Uri artistsUri = Uri.https(
    _host,
    '/artists.json',
  );

  Future<Map<String, Artist>> _fetchAllArtists() async {
    final http.Response response = await http.get(artistsUri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(json.decode(response.body) as Map);
      final Map<String, Artist> artists = {};
      data.forEach((id, artistJson) {
        artists[id] = ArtistDto.fromJson(id, Map<String, dynamic>.from(artistJson as Map));
      });
      return artists;
    } else {
      throw Exception('Failed to load artists');
    }
  }

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(json.decode(response.body) as Map);
      
      // Fetch all artists to join with songs
      final artistsMap = await _fetchAllArtists();
      
      final List<Song> songs = data.entries
          .map(
            (entry) {
              final songJson = Map<String, dynamic>.from(entry.value as Map);
              final artistId = songJson['artistId'] as String;
              final artist = artistsMap[artistId];
              
              return SongDto.fromJson(
                entry.key,
                songJson,
                artistName: artist?.name ?? 'Unknown Artist',
                artistGenre: artist?.genre ?? 'Unknown Genre',
              );
            },
          )
          .toList();
      return songs;
    } else {
      throw Exception('Failed to load songs');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    final Uri songUri = Uri.https(_host, '/songs/$id.json');
    final http.Response response = await http.get(songUri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load song: $id');
    }

    if (response.body == 'null') {
      return null;
    }

    final Map<String, dynamic> songJson =
        Map<String, dynamic>.from(json.decode(response.body) as Map);
    
    // Fetch artist for this song
    final artistId = songJson['artistId'] as String;
    final Uri artistUri = Uri.https(_host, '/artists/$artistId.json');
    final artistResponse = await http.get(artistUri);
    
    String artistName = 'Unknown Artist';
    String artistGenre = 'Unknown Genre';
    
    if (artistResponse.statusCode == 200 && artistResponse.body != 'null') {
      final artistJson = Map<String, dynamic>.from(json.decode(artistResponse.body) as Map);
      final artist = ArtistDto.fromJson(artistId, artistJson);
      artistName = artist.name;
      artistGenre = artist.genre;
    }
    
    return SongDto.fromJson(id, songJson, artistName: artistName, artistGenre: artistGenre);
  }

  @override
  Future<Song> likeSong(String id, int newLikeCount) async {
    final Uri likeUri = Uri.https(_host, '/songs/$id/likes.json');
    final http.Response response = await http.put(
      likeUri,
      body: json.encode(newLikeCount),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update likes for song: $id');
    }

    final Song? song = await fetchSongById(id);
    if (song == null) {
      throw Exception('Song not found after like update: $id');
    }
    return song;
  }
}
