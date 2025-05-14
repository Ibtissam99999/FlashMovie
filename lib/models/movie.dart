class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final double voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
  });

  // Méthode fromJson pour transformer le JSON en un objet Movie
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] is int)
          ? (json['vote_average'] as int).toDouble()
          : json['vote_average'] ?? 0.0,
    );
  }

  // Méthode fromMap corrigée
  static Movie fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      overview: map['overview'],
      posterPath: map['poster_path'],
      releaseDate: map['releaseDate'],
      voteAverage: map['vote_average'],
    );
  }

  // Méthode toMap pour transformer l'objet Movie en une Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'releaseDate': releaseDate,
      'vote_average': voteAverage,
    };
  }
}
