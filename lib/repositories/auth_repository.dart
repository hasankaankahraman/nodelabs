import '../services/api_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository({required this.apiService});

  Future<UserModel> login(String email, String password) async {
    final response = await apiService.postRequest("login", {
      "email": email,
      "password": password,
    });

    if (response["response"]["code"] == 200) {
      return UserModel.fromJson(response["data"]);
    } else {
      throw Exception(response["response"]["message"]);
    }
  }
}
