class Song {
  final String id;
  final String title;
  final String artistId;
  final String artistName;
  final String artistGenre;
  final Duration duration;
  final Uri imageUrl;
  final int likes;

  Song({
    required this.id,
    required this.title,
    required this.artistId,
    required this.artistName,
    required this.artistGenre,
    required this.duration,
    required this.imageUrl,
    this.likes = 0,
  });

  @override
  String toString() {
    return 'Song(id: $id, title: $title, artistId: $artistId, artistName: $artistName, artistGenre: $artistGenre, duration: $duration, imageUrl: $imageUrl, likes: $likes)';
  }

  /// Create a new Song with updated values
  Song copyWith({int? likes, String? artistName, String? artistGenre}) {
    return Song(
      id: id,
      title: title,
      artistId: artistId,
      artistName: artistName ?? this.artistName,
      artistGenre: artistGenre ?? this.artistGenre,
      duration: duration,
      imageUrl: imageUrl,
      likes: likes ?? this.likes,
    );
  }
}
