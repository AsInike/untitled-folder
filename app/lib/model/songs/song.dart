class Song {
  final String id;
  final String title;
  final String artistId;
  final Duration duration;
  final Uri imageUrl;
  final int likes;

  Song({
    required this.id,
    required this.title,
    required this.artistId,
    required this.duration,
    required this.imageUrl,
    this.likes = 0,
  });

  @override
  String toString() {
    return 'Song(id: $id, title: $title, artistId: $artistId, duration: $duration, imageUrl: $imageUrl, likes: $likes)';
  }

  /// Create a new Song with updated likes
  Song copyWith({int? likes}) {
    return Song(
      id: id,
      title: title,
      artistId: artistId,
      duration: duration,
      imageUrl: imageUrl,
      likes: likes ?? this.likes,
    );
  }
}
