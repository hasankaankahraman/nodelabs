import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:nodelabs/models/user_model.dart';

class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel user;
  AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

class AuthCubit extends Cubit<AuthState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://caseapi.nodelabs.dev/user"));

  AuthCubit() : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    try {
      final response = await _dio.post("/login", data: {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200 && response.data['response']['code'] == 200) {
        final userData = response.data['data'];
        final user = UserModel.fromJson(userData);

        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure("Giriş başarısız!"));
      }
    } catch (e) {
      emit(AuthFailure("Bir hata oluştu: $e"));
    }
  }

  Future<void> signup(String name, String email, String password) async {
    emit(AuthLoading());

    try {
      final response = await _dio.post("/register", data: {
        "name": name,
        "email": email,
        "password": password,
      });

      // 📌 API yanıtını debug için konsolda gösterelim
      print("📌 API Yanıtı: ${response.statusCode} - ${response.data}");

      // ✅ Başarılı Yanıt Kontrolü
      if (response.statusCode == 200 && response.data.containsKey("token")) {
        final userData = response.data["user"];
        final user = UserModel.fromJson(userData);
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure("🚨 Kayıt başarısız, API'den geçerli yanıt gelmedi."));
      }
    } catch (e) {
      // 📌 Hata detaylarını konsolda gösterelim
      print("❌ Hata Detayı: $e");

      // 📌 API'nin neden hata verdiğini anlamamız için Dio hata türlerini kontrol edelim
      if (e is DioException) {
        if (e.response != null) {
          print("⚠️ API Hata Yanıtı: ${e.response!.data}");
          emit(AuthFailure("🚨 API Hatası: ${e.response!.data}"));
        } else {
          emit(AuthFailure("🚨 Sunucuya ulaşılamıyor, internet bağlantınızı kontrol edin."));
        }
      } else {
        emit(AuthFailure("🚨 Bir hata oluştu: $e"));
      }
    }
  }
}
