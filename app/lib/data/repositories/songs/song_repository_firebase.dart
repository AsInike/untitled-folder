import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  static const String _host =
      'week-8-practice-265f7-default-rtdb.asia-southeast1.firebasedatabase.app';

  final Uri songsUri = Uri.https(
    _host,
    '/songs.json',
  );

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(json.decode(response.body) as Map);
      final List<Song> songs = data.entries
          .map(
            (entry) => SongDto.fromJson(
              entry.key,
              Map<String, dynamic>.from(entry.value as Map),
            ),
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
    return SongDto.fromJson(id, songJson);
  }
}
