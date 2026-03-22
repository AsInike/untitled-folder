import '../../../model/artists/artist.dart';
import 'artist_repository.dart';

class ArtistRepositoryMock implements ArtistRepository {
  final List<Artist> _artists = [
    Artist(
      id: 'artist_1',
      name: 'VannDa',
      genre: 'Hip-Hop',
      imageUrl: Uri.parse('https://images.unsplash.com/photo-1511379938547-c1f69419868d'),
    ),
    Artist(
      id: 'artist_2',
      name: 'Tena',
      genre: 'Pop',
      imageUrl: Uri.parse('https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91'),
    ),
    Artist(
      id: 'artist_3',
      name: 'G-Devith',
      genre: 'Hip-Hop',
      imageUrl: Uri.parse('https://images.unsplash.com/photo-1497032205916-ac775f0649ae'),
    ),
    Artist(
      id: 'artist_4',
      name: 'Sokun Nisa',
      genre: 'Pop',
      imageUrl: Uri.parse('https://images.unsplash.com/photo-1494790108377-be9c29b29330'),
    ),
    Artist(
      id: 'artist_5',
      name: 'Ravuth',
      genre: 'Indie',
      imageUrl: Uri.parse('https://images.unsplash.com/photo-1500648767791-00dcc994a43e'),
    ),
  ];

  @override
  Future<List<Artist>> fetchArtists() async {
    return Future.delayed(Duration(seconds: 2), () {
      return _artists;
    });
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    return Future.delayed(Duration(seconds: 2), () {
      return _artists.firstWhere(
        (artist) => artist.id == id,
        orElse: () => throw Exception("No artist with id $id in the database"),
      );
    });
  }
}
