import 'package:nodelabs/models/movie_model.dart';
import 'package:nodelabs/services/api_service.dart';

class MovieRepository {
  final ApiService apiService;

  MovieRepository({required this.apiService});

  Future<Map<String, dynamic>> fetchMovies(String token, {int page = 1}) async {
    try {
      final response = await apiService.getRequest("movie/list?page=$page", token: token);

      // ✅ Null check'leri ekleyin
      final data = response['data'] ?? {}; // Data yoksa boş map kullan
      final moviesData = data['movies'] as List? ?? []; // Movies yoksa boş liste
      final pagination = data['pagination'] as Map<String, dynamic>? ?? {}; // Pagination yoksa boş map

      return {
        "movies": moviesData.map((movie) => MovieModel.fromJson(movie)).toList(),
        "currentPage": (pagination['currentPage'] as int?) ?? 1, // Default değer
        "maxPage": (pagination['maxPage'] as int?) ?? 1, // Default değer
      };
    } catch (e) {
      print("❌ MovieRepository Error: ${e.toString()}");
      throw Exception("Filmler yüklenemedi");
    }
  }
}
