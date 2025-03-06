import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_state.dart';
import 'package:nodelabs/models/movie_model.dart';
import 'package:nodelabs/repositories/movie_repository.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieRepository movieRepository;

  int currentPage = 1;
  final int perPage = 5; // ✅ API’de belirtilen perPage değerine göre ayarla
  bool isFetching = false; // ✅ Aynı anda birden fazla istek atılmasını engellemek için

  MovieCubit({required this.movieRepository}) : super(MovieInitial());

  void fetchMovies(String token, {bool isLoadMore = false}) async {
    if (isFetching) return;
    isFetching = true;

    try {
      if (!isLoadMore) {
        emit(MovieLoading());
      }

      // ✅ API'den gelen "pagination" bilgisini al
      final response = await movieRepository.fetchMovies(token, page: currentPage);
      final newMovies = response["movies"] as List<MovieModel>;
      final int totalCount = response["totalCount"];
      final int maxPage = response["maxPage"];
      final bool hasMore = currentPage < maxPage; // ✅ Eğer daha fazla sayfa varsa, true yap

      if (state is MovieLoaded) {
        final List<MovieModel> currentMovies = (state as MovieLoaded).movies;
        emit(MovieLoaded(movies: [...currentMovies, ...newMovies], hasMore: hasMore));
      } else {
        emit(MovieLoaded(movies: newMovies, hasMore: hasMore));
      }

      if (hasMore) {
        currentPage++; // ✅ Sayfayı artır (eğer daha fazla veri varsa)
      }
    } catch (e) {
      emit(MovieError(error: e.toString()));
    }

    isFetching = false;
  }
}
