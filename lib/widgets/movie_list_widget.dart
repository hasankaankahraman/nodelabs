import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_cubit.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_state.dart';
import 'package:nodelabs/core/cubits/auth_cubit/auth_cubit.dart'; // ✅ AuthCubit import edildi
import '../widgets/movie_card_widget.dart';

class MovieListWidget extends StatefulWidget {
  @override
  _MovieListWidgetState createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        // 📌 Sayfa sonuna yaklaşınca yeni verileri getir
        final movieCubit = context.read<MovieCubit>();
        final state = movieCubit.state;

        if (state is MovieLoaded && state.hasMore) {
          // ✅ Kullanıcının giriş yapıp yapmadığını kontrol et
          final authState = context.read<AuthCubit>().state;
          if (authState is AuthSuccess) {
            final token = authState.user.token;
            movieCubit.fetchMovies(token, isLoadMore: true);
          } else {
            print("❌ Kullanıcı oturum açmamış! Token alınamıyor.");
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieCubit, MovieState>(
      builder: (context, state) {
        if (state is MovieLoading) {
          return Center(child: CircularProgressIndicator()); // ✅ İlk yüklenme ekranı
        } else if (state is MovieLoaded) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.movies.length + (state.hasMore ? 1 : 0), // ✅ hasMore varsa 1 ekle
            itemBuilder: (context, index) {
              if (index < state.movies.length) {
                return MovieCardWidget(movie: state.movies[index]);
              } else {
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()), // ✅ Daha fazla yükleniyor göster
                );
              }
            },
          );
        } else if (state is MovieError) {
          return Center(child: Text("Hata: ${state.error}"));
        } else {
          return Center(child: Text("Henüz film yok."));
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
