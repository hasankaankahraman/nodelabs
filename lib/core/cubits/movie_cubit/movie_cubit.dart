import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_state.dart';
import 'package:nodelabs/models/movie_model.dart';
import 'package:nodelabs/repositories/movie_repository.dart';
import 'package:nodelabs/services/api_service.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieRepository _repository;
  final ApiService _apiService = ApiService();
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  List<MovieModel> _movies = [];

  MovieCubit(this._repository) : super(MovieInitial());

  Future<void> fetchMovies(String token, {bool loadMore = false}) async {
    if (_isLoading || (loadMore && !_hasMore)) return;

    _isLoading = true;
    try {
      final response = await _repository.fetchMovies(token, page: loadMore ? _currentPage + 1 : 1);

      // ✅ Response değerlerini kontrol edin
      final newMovies = response["movies"] as List<MovieModel>? ?? [];
      final currentPage = response["currentPage"] as int? ?? 1;
      final maxPage = response["maxPage"] as int? ?? 1;

      // Eğer favoriler yüklüyse, favorileri işaretle
      if (!loadMore) {
        await _markFavoriteMovies(newMovies, token);
      }

      // State güncelleme
      _movies = loadMore ? [..._movies, ...newMovies] : newMovies;
      _currentPage = currentPage;
      _hasMore = currentPage < maxPage;

      emit(MovieLoaded(movies: _movies, hasMore: _hasMore));
    } catch (e) {
      // ✅ Hata mesajını daha spesifik hale getirin
      emit(MovieError(error: "Hata: ${e.toString()}"));
      if (loadMore) emit(MovieLoaded(movies: _movies, hasMore: _hasMore));
    } finally {
      _isLoading = false;
    }
  }

  // Favori filmlerini işaretleme yardımcı metodu
  Future<void> _markFavoriteMovies(List<MovieModel> movies, String token) async {
    try {
      final favoriteMovies = await _apiService.getFavoriteMovies(token);

      // Favorileri işaretle
      for (var movie in movies) {
        movie.isFavorite = favoriteMovies.any((favMovie) => favMovie.id == movie.id);
      }
    } catch (e) {
      print("Favorileri yüklerken hata: ${e.toString()}");
    }
  }

  // Favori durumunu değiştirme metodu
  Future<void> toggleMovieFavorite(String movieId, String token) async {
    try {
      // Önce mevcut favori durumunu kaydet
      final movieIndex = _movies.indexWhere((movie) => movie.id == movieId);
      if (movieIndex == -1) return;

      final currentMovie = _movies[movieIndex];
      final oldFavoriteStatus = currentMovie.isFavorite;

      // UI'ı hemen güncelle (optimistik güncelleme)
      final updatedMovies = List<MovieModel>.from(_movies);
      updatedMovies[movieIndex] = MovieModel(
          id: currentMovie.id,
          title: currentMovie.title,
          description: currentMovie.description,
          posterUrl: currentMovie.posterUrl,
          producer: currentMovie.producer,
          isFavorite: !oldFavoriteStatus
      );

      _movies = updatedMovies;
      emit(MovieLoaded(movies: _movies, hasMore: _hasMore));

      // API çağrısını yap
      await _apiService.toggleFavorite(movieId, token);

      // Tüm favori filmlerini yeniden yükle ve işaretle
      final favoriteMovies = await _apiService.getFavoriteMovies(token);

      // Tüm film listesini güncelle
      final refreshedMovies = List<MovieModel>.from(_movies);
      for (int i = 0; i < refreshedMovies.length; i++) {
        final movie = refreshedMovies[i];
        movie.isFavorite = favoriteMovies.any((favMovie) => favMovie.id == movie.id);
      }

      _movies = refreshedMovies;
      emit(MovieLoaded(movies: _movies, hasMore: _hasMore));

      print("⭐ Favori durumu güncellendi: ${currentMovie.title} - yeni durum: ${!oldFavoriteStatus}");
    } catch (e) {
      emit(MovieError(error: "Favori işlemi gerçekleştirilemedi: ${e.toString()}"));
      // Hata sonrası mevcut verileri tekrar yükle
      emit(MovieLoaded(movies: _movies, hasMore: _hasMore));
    }
  }
}