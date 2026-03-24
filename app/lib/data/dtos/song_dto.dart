    import '../../model/songs/song.dart';

class SongDto {
  static const String artistKey = 'artistId';
  static const String durationKey = 'duration'; 
  static const String imageUrlKey = 'imageUrl'; 
  static const String titleKey = 'title';
  static const String likesKey = 'likes';
 
  static Song fromJson(String id, Map<String, dynamic> json, {String artistName = '', String artistGenre = ''}) {
  
    assert(json[titleKey] is String);
    assert(json[artistKey] is String);
    assert(json[durationKey] is int);
    assert(json[imageUrlKey] is String);

    return Song(
      id: id,
      title: json[titleKey],
      artistId: json[artistKey],
      artistName: artistName,
      artistGenre: artistGenre,
      duration: Duration(milliseconds: json[durationKey]),
      imageUrl: Uri.parse(json[imageUrlKey]),
      likes: json[likesKey] as int? ?? 0,
    );
  }

  /// Convert Song to JSON
  Map<String, dynamic> toJson(Song song) {
    return {
      titleKey: song.title,
      artistKey: song.artistId,
      durationKey: song.duration.inMilliseconds,
      imageUrlKey: song.imageUrl.toString(),
      likesKey: song.likes,
    };
  }
}
