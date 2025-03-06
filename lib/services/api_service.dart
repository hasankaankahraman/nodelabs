import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

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
}
