// song_repository_mock.dart

import '../../../model/songs/song.dart';
import 'song_repository.dart';

class SongRepositoryMock implements SongRepository {
  final List<Song> _songs = [
    Song(
      id: 's1',
      title: 'Mock Song 1',
      artistId: 'artist_1',
      artistName: 'VannDa',
      artistGenre: 'Hip-Hop',
      duration: const Duration(minutes: 2, seconds: 50),
      imageUrl: Uri.parse('https://picsum.photos/100/100?random=1'),
    ),
    Song(
      id: 's2',
      title: 'Mock Song 2',
      artistId: 'artist_1',
      artistName: 'VannDa',
      artistGenre: 'Hip-Hop',
      duration: const Duration(minutes: 3, seconds: 20),
      imageUrl: Uri.parse('https://picsum.photos/100/100?random=2'),
    ),
    Song(
      id: 's3',
      title: 'Mock Song 3',
      artistId: 'artist_2',
      artistName: 'Tena',
      artistGenre: 'Pop',
      duration: const Duration(minutes: 3, seconds: 20),
      imageUrl: Uri.parse('https://picsum.photos/100/100?random=3'),
    ),
    Song(
      id: 's4',
      title: 'Mock Song 4',
      artistId: 'artist_2',
      artistName: 'Tena',
      artistGenre: 'Pop',
      duration: const Duration(minutes: 3, seconds: 20),
      imageUrl: Uri.parse('https://picsum.photos/100/100?random=4'),
    ),
    Song(
      id: 's5',
      title: 'Mock Song 5',
      artistId: 'artist_3',
      artistName: 'G-Devith',
      artistGenre: 'Hip-Hop',
      duration: const Duration(minutes: 3, seconds: 20),
      imageUrl: Uri.parse('https://picsum.photos/100/100?random=5'),
    ),
  ];

  @override
  Future<List<Song>> fetchSongs() async {
    return Future.delayed(Duration(seconds: 4), () {
      throw Exception("G3 and G4 the class is finished");
    });
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    return Future.delayed(Duration(seconds: 4), () {
      return _songs.firstWhere(
        (song) => song.id == id,
        orElse: () => throw Exception("No song with id $id in the database"),
      );
    });
  }

  @override
  Future<Song> likeSong(String id, int newLikeCount) async {
    return Future.delayed(Duration(seconds: 1), () {
      final index = _songs.indexWhere((song) => song.id == id);
      if (index == -1) {
        throw Exception("No song with id $id in the database");
      }
      final updatedSong = _songs[index].copyWith(likes: newLikeCount);
      _songs[index] = updatedSong;
      return updatedSong;
    });
  }
}
