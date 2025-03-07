class MovieModel {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final String producer;
  bool isFavorite;

  MovieModel({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.producer,
    this.isFavorite = false,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    // ✅ Poster URL null kontrolü ve HTTP → HTTPS dönüşümü
    final rawPosterUrl = (json["Poster"] as String?)?.replaceFirst("http://", "https://") ?? "";

    return MovieModel(
      id: (json["id"] ?? json["_id"] ?? "").toString(), // Hem id hem _id kontrolü
      title: (json["Title"] as String?) ?? "Bilinmeyen Film",
      description: (json["Plot"] as String?) ?? "Açıklama mevcut değil",
      posterUrl: rawPosterUrl.isNotEmpty
          ? rawPosterUrl
          : "https://via.placeholder.com/500x750.png?text=No+Image",
      producer: (json["Producer"] as String?) ?? "Bilinmeyen Yapımcı",
      isFavorite: (json["isFavorite"] as bool?) ?? false,
    );
  }
}