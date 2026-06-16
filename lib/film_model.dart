class FilmModel {
  final String id;
  final String title;
  final String description;
  final String director;
  final String image;

  FilmModel({
    required this.id,
    required this.title,
    required this.description,
    required this.director,
    required this.image,
  });

  factory FilmModel.fromJson(Map<String, dynamic> json) {
    return FilmModel(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Brak tytułu',
      description: json['description'] ?? 'Brak opisu',
      director: json['director'] ?? 'Nieznany',
      image: json['image'],
    );
  }
}