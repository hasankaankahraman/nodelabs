import 'package:equatable/equatable.dart';
import 'package:nodelabs/models/movie_model.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoadingMore extends MovieState {
  final List<MovieModel> movies;

  const MovieLoadingMore({required this.movies});

  @override
  List<Object> get props => [movies];
}

class MovieLoaded extends MovieState {
  final List<MovieModel> movies;
  final bool hasMore;

  const MovieLoaded({required this.movies, required this.hasMore});

  @override
  List<Object> get props => [movies, hasMore];
}

class MovieError extends MovieState {
  final String error;

  const MovieError({required this.error});

  @override
  List<Object> get props => [error];
}