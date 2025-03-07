import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:nodelabs/models/movie_model.dart';
import 'package:nodelabs/models/user_model.dart';

class ApiService {
  static const String baseUrl = "https://caseapi.nodelabs.dev";

  // ✅ GET Request (Tüm GET istekleri için kullanılabilir)
  Future<Map<String, dynamic>> getRequest(String endpoint, {String? token, Map<String, String>? extraHeaders}) async {
    final url = Uri.parse("$baseUrl/$endpoint");

    final headers = {
      'accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?extraHeaders, // Ekstra header eklemek için
    };

    final response = await http.get(url, headers: headers);

    print("📌 GET Request: $url");
    print("📌 Status Code: ${response.statusCode}");
    print("📌 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("API Hatası: ${response.body}");
    }
  }

  // ✅ POST Request
  Future<Map<String, dynamic>> postRequest(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/$endpoint");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    print("📌 POST Request: $url");
    print("📌 Status Code: ${response.statusCode}");
    print("📌 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("API Hatası: ${response.body}");
    }
  }

  // ✅ Fotoğraf Yükleme
  Future<String?> uploadProfilePhoto(File imageFile, String token) async {
    final url = Uri.parse("$baseUrl/user/upload_photo");

    var request = http.MultipartRequest("POST", url);
    request.headers['accept'] = "application/json";
    request.headers['Authorization'] = "Bearer $token";

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    var response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print("📌 Fotoğraf Yükleme Response: $responseBody");

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(responseBody);
      return decodedData["data"]["photoUrl"];
    } else {
      print("❌ Fotoğraf yükleme başarısız: $responseBody");
      return null;
    }
  }

  Future<UserModel> getUserProfile(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/user/profile"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['data'];
      return UserModel.fromJson(data);
    } else {
      throw Exception("Profil bilgisi alınamadı");
    }
  }

  Future<bool> toggleFavorite(String movieId, String token) async {
    final url = Uri.parse("https://caseapi.nodelabs.dev/movie/favorite/$movieId");

    // Authorization header ekliyoruz
    final response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token', // Token'ı header'a ekliyoruz
      },
    );

    print("📌 POST Request: $url");
    print("📌 Status Code: ${response.statusCode}");
    print("📌 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['success'] ?? false;
    } else {
      throw Exception("API Hatası: ${response.body}");
    }
  }


// Favori filmleri al
  Future<List<MovieModel>> getFavoriteMovies(String token) async {
    final url = Uri.parse("$baseUrl/movie/favorites");

    // Authorization header'ı ekliyoruz
    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token', // Token'ı burada Authorization header'ına ekliyoruz
      },
    );

    print("📌 GET Request: $url");
    print("📌 Status Code: ${response.statusCode}");
    print("📌 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<MovieModel> favoriteMovies = [];
      for (var movie in responseData['movies']) {
        favoriteMovies.add(MovieModel.fromJson(movie)); // MovieModel'e dönüştürüp listeye ekliyoruz
      }
      return favoriteMovies;
    } else {
      throw Exception("API Hatası: ${response.body}");
    }
  }

}
