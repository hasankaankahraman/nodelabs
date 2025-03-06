class PostModel {
  final String imageUrl;
  final String username;
  final String profileImageUrl;
  final String title;
  final String description;

  PostModel({
    required this.imageUrl,
    required this.username,
    required this.profileImageUrl,
    required this.title,
    required this.description,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      imageUrl: json['image_url'] ?? '',
      username: json['username'] ?? 'Bilinmeyen Kullanıcı',
      profileImageUrl: json['profile_image_url'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
