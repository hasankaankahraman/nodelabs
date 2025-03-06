import 'package:equatable/equatable.dart';
import 'package:nodelabs/models/movie_model.dart';

abstract class MovieState extends Equatable {
  @override
  List<Object?> get props => [];
}

// 📌 Başlangıç State'i
class MovieInitial extends MovieState {}

// 📌 Yükleniyor State'i
class MovieLoading extends MovieState {}

// 📌 Yükleme Başarılı (Film Listesi Geldi)
class MovieLoaded extends MovieState {
  final List<MovieModel> movies;
  final bool hasMore; // ✅ API'den gelen total sayfa sayısına göre daha fazla veri olup olmadığını kontrol edecek

  MovieLoaded({required this.movies, required this.hasMore}); // ✅ hasMore ekledik

  @override
  List<Object?> get props => [movies, hasMore];
}

// 📌 Hata Durumu
class MovieError extends MovieState {
  final String error;

  MovieError({required this.error});

  @override
  List<Object?> get props => [error];
}
