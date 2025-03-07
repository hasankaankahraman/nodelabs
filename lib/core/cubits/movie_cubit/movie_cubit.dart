import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_state.dart';
import 'package:nodelabs/models/movie_model.dart';
import 'package:nodelabs/repositories/movie_repository.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieRepository _repository;
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
}