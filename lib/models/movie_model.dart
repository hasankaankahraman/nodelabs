class MovieModel {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  bool isFavorite; // Favori durumu ekledik

  MovieModel({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    this.isFavorite = false, // Varsayılan olarak false
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    String rawPosterUrl = json["Poster"] ?? "";

    // ✅ Eğer HTTP varsa HTTPS yapalım
    if (rawPosterUrl.startsWith("http://")) {
      rawPosterUrl = rawPosterUrl.replaceFirst("http://", "https://");
    }

    // ✅ Eğer poster URL yoksa veya boşsa, varsayılan bir görsel kullan
    String finalPosterUrl = rawPosterUrl.isNotEmpty
        ? rawPosterUrl
        : "https://via.placeholder.com/500x750.png?text=No+Image";

    return MovieModel(
      id: json["id"] ?? "",
      title: json["Title"] ?? "Bilinmeyen Film",
      description: json["Plot"] ?? "Açıklama mevcut değil",
      posterUrl: finalPosterUrl,
      isFavorite: json["isFavorite"] ?? false, // Eğer API'den geliyorsa, kullan
    );
  }
}
