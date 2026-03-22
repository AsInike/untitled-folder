import 'package:flutter/material.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final PlayerState playerState;

  AsyncValue<List<Song>> songsValue = AsyncValue.loading();

  LibraryViewModel({required this.songRepository, required this.playerState}) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSong();
  }

  void fetchSong() async {
    // 1- Loading state
    songsValue = AsyncValue.loading();
    notifyListeners();

    try {
      // 2- Fetch is successfull
      List<Song> songs = await songRepository.fetchSongs();
      songsValue = AsyncValue.success(songs);
    } catch (e) {
      // 3- Fetch is unsucessfull
      songsValue = AsyncValue.error(e);
    }
     notifyListeners();

  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();

  void likeSong(Song song) async {
    try {
      // Increment likes by 1
      final updatedSong = await songRepository.likeSong(song.id, song.likes + 1);
      
      // Update the song in the list
      if (songsValue.data != null) {
        final songs = songsValue.data!;
        final index = songs.indexWhere((s) => s.id == song.id);
        if (index != -1) {
          songs[index] = updatedSong;
          songsValue = AsyncValue.success(songs);
          notifyListeners();
        }
      }
    } catch (e) {
      songsValue = AsyncValue.error(e);
      notifyListeners();
    }
  }
}
