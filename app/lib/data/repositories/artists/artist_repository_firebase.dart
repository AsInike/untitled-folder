import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/artists/artist.dart';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase extends ArtistRepository {
  static const String _host =
      'week-8-practice-265f7-default-rtdb.asia-southeast1.firebasedatabase.app';

  final Uri artistsUri = Uri.https(
    _host,
    '/artists.json',
  );

  @override
  Future<List<Artist>> fetchArtists() async {
    final http.Response response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(json.decode(response.body) as Map);
      final List<Artist> artists = data.entries
          .map(
            (entry) => ArtistDto.fromJson(
              entry.key,
              Map<String, dynamic>.from(entry.value as Map),
            ),
          )
          .toList();
      return artists;
    } else {
      throw Exception('Failed to load artists');
    }
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    final Uri artistUri = Uri.https(_host, '/artists/$id.json');
    final http.Response response = await http.get(artistUri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load artist: $id');
    }

    if (response.body == 'null') {
      return null;
    }

    final Map<String, dynamic> artistJson =
        Map<String, dynamic>.from(json.decode(response.body) as Map);
    return ArtistDto.fromJson(id, artistJson);
  }
}
