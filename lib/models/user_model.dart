class UserModel {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
