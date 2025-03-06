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
  bool _isFetching = false; // 📌 Aynı anda birden fazla istek atılmasını engellemek için

  @override
  void initState() {
    super.initState();
    context.read<MovieCubit>().fetchMovies(widget.userToken); // İlk yükleme

    // 📌 Sayfa değişiminde yeni veri çekmek için listener ekle
    _pageController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_pageController.position.pixels == _pageController.position.maxScrollExtent) {
      if (!_isFetching) {
        setState(() => _isFetching = true); // Yeni istek başlamadan önce isFetching'i güncelle

        context.read<MovieCubit>().fetchMovies(widget.userToken, isLoadMore: true);

        // API çağrısı tamamlandıktan sonra tekrar veri çekilmesini sağlamak için gecikme ekleyelim
        Future.delayed(Duration(seconds: 1), () {
          if (mounted) {
            setState(() => _isFetching = false);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_handleScroll); // 📌 Listener'ı kaldır
    _pageController.dispose();
    super.dispose();
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
            scrollDirection: Axis.vertical, // 📌 TikTok tarzı dikey kaydırma
            itemCount: state.movies.length + 1, // 📌 Ekstra 1 ekleyerek "yükleniyor" gösterebiliriz
            itemBuilder: (context, index) {
              if (index == state.movies.length) {
                return Center(child: CircularProgressIndicator()); // 📌 Yeni veriler yüklenirken göster
              }
              return MovieCardWidget(movie: state.movies[index]);
            },
          );
        } else {
          return Center(child: Text("Bir hata oluştu", style: TextStyle(color: Colors.white)));
        }
      },
    );
  }
}
