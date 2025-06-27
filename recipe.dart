class Recipe {
  final int? id;
  final String name;
  final String description;
  final String image;
  final String url;
  bool isFavorite;

  Recipe({
    this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.url,
    required this.isFavorite,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'url': url,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      url: map['url'] as String,
      isFavorite: map['isFavorite'] == 1,
    );
  }
}
