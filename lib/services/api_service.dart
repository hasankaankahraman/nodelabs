import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "https://caseapi.nodelabs.dev/user";

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

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("API Hatası: ${response.body}");
    }
  }

  Future<String?> uploadProfilePhoto(File imageFile, String token) async {
    final url = Uri.parse("$baseUrl/upload_photo");

    var request = http.MultipartRequest("POST", url);
    request.headers['accept'] = "application/json";
    request.headers['Authorization'] = "Bearer $token";

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    var response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(responseBody);
      return decodedData["data"]["photoUrl"]; // ✅ API'den dönen foto URL'si
    } else {
      print("❌ Fotoğraf yükleme başarısız: $responseBody");
      return null;
    }
  }
}
