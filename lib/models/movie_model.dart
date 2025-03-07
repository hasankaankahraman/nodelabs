class MovieModel {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final String producer; // ✅ Producer alanı eklendi
  bool isFavorite; // Favori durumu

  MovieModel({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.producer, // ✅ Producer zorunlu hale getirildi
    this.isFavorite = false,
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
      producer: json["Producer"] ?? "Bilinmeyen Yapımcı", // ✅ Producer eklendi
      isFavorite: json["isFavorite"] ?? false,
    );
  }
}
