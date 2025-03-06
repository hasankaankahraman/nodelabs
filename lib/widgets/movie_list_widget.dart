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
  int _currentIndex = 0; // Şu an hangi sayfada olduğumuzu takip etmek için

  @override
  void initState() {
    super.initState();

    // Sayfa değiştirildiğinde kontrol etmek için listener ekle
    _pageController.addListener(() {
      if (_pageController.page == _currentIndex + 1) {
        _currentIndex++;
        context.read<MovieCubit>().fetchMovies(widget.userToken, isLoadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieCubit, MovieState>(
      builder: (context, state) {
        if (state is MovieLoading && state is! MovieLoaded) {
          return Center(child: CircularProgressIndicator());
        } else if (state is MovieLoaded) {
          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical, // 📌 Yukarı-aşağı kaydırma
            itemCount: state.movies.length,
            itemBuilder: (context, index) {
              return MovieCardWidget(movie: state.movies[index]);
            },
          );
        } else {
          return Center(child: Text("Bir hata oluştu", style: TextStyle(color: Colors.white)));
        }
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
