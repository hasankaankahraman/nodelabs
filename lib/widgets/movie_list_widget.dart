import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_cubit.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_state.dart';
import '../widgets/movie_card_widget.dart';

class MovieListWidget extends StatefulWidget {
  final String userToken;

  const MovieListWidget({Key? key, required this.userToken}) : super(key: key);

  @override
  _MovieListWidgetState createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<MovieCubit>().fetchMovies(widget.userToken);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieCubit, MovieState>(
      builder: (context, state) {
        if (state is MovieLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is MovieLoaded) {
          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: state.movies.length + 1,
            itemBuilder: (context, index) {
              if (index == state.movies.length) {
                return Center(child: CircularProgressIndicator());
              }
              final movie = state.movies[index];
              return MovieCardWidget(
                movie: movie,
                isFavorite: movie.isFavorite,
                userToken: widget.userToken,  // Token'ı buraya geçiyoruz
              );
            },
          );
        } else {
          return Center(child: Text("Bir hata oluştu", style: TextStyle(color: Colors.white)));
        }
      },
    );
  }
}
