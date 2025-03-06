import 'package:nodelabs/models/movie_model.dart';
import 'package:nodelabs/services/api_service.dart';

class MovieRepository {
  final ApiService apiService;

  MovieRepository({required this.apiService});

  Future<Map<String, dynamic>> fetchMovies(String token, {int page = 1}) async {
    try {
      final data = await apiService.getRequest("movie/list?page=$page", token: token);

      if (data['data'] == null || data['data']['movies'] == null || data['data']['pagination'] == null) {
        throw Exception("API yanıtı beklenen formatta değil!");
      }

      final List movies = data['data']['movies'];
      final int totalCount = data['data']['pagination']['totalCount']; // ✅ Toplam film sayısı
      final int perPage = data['data']['pagination']['perPage']; // ✅ Sayfa başına film sayısı
      final int maxPage = data['data']['pagination']['maxPage']; // ✅ Maksimum sayfa sayısı
      final int currentPage = data['data']['pagination']['currentPage']; // ✅ Mevcut sayfa
      final bool hasMore = currentPage < maxPage; // ✅ Daha fazla sayfa olup olmadığını kontrol et

      return {
        "movies": movies.map((movie) => MovieModel.fromJson(movie)).toList(),
        "totalCount": totalCount,
        "maxPage": maxPage,
        "hasMore": hasMore,
      };
    } catch (e) {
      print("❌ API Hata: $e");
      throw Exception("API hatası: $e");
    }
  }
}
