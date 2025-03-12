import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nodelabs/core/app_colors.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_cubit.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_state.dart';
import '../models/movie_model.dart';

class MovieCardWidget extends StatefulWidget {
  final MovieModel movie;
  final String userToken;

  const MovieCardWidget({
    Key? key,
    required this.movie,
    required this.userToken,
  }) : super(key: key);

  @override
  _MovieCardWidgetState createState() => _MovieCardWidgetState();
}

class _MovieCardWidgetState extends State<MovieCardWidget> {
  // Local state for the favorite status
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.movie.isFavorite;
  }

  @override
  void didUpdateWidget(MovieCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.movie.isFavorite != widget.movie.isFavorite) {
      setState(() {
        _isFavorite = widget.movie.isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MovieCubit, MovieState>(
      listener: (context, state) {
        if (state is MovieLoaded) {
          // Find current movie in state
          final currentMovie = state.movies.firstWhere(
                (m) => m.id == widget.movie.id,
            orElse: () => widget.movie,
          );

          // Update local state if needed
          if (_isFavorite != currentMovie.isFavorite) {
            setState(() {
              _isFavorite = currentMovie.isFavorite;
            });
          }
        }
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Arka planda tam ekran poster
            Image.network(
              widget.movie.posterUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset("assets/default_poster.png", fit: BoxFit.cover);
              },
            ),

            // Siyah degrade efekti
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Filmin bilgilerini alta yapıştır
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık
                  Text(
                    widget.movie.title,
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  // Yapımcı bilgisi
                  Text(
                    "Yapımcı: ${widget.movie.producer}",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  // Açıklama
                  Text(
                    widget.movie.description,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Kalp ikonunu ekranın ortasına sağa yapıştır
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 25,
              right: 20,
              child: Container(
                height: 80,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    _isFavorite ? 'assets/fav_icon.svg' : 'assets/favnot_icon.svg',
                    color: Colors.white,
                    width: 50,
                    height: 50,
                  ),
                  onPressed: () {
                    // Optimistik güncelleme için önce yerel durumu değiştir
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });

                    // Sonra sunucu durumunu güncelle
                    context.read<MovieCubit>().toggleMovieFavorite(widget.movie.id, widget.userToken);
                    print("⭐ Favori butonu tıklandı: ${widget.movie.title} - yeni durum: $_isFavorite");
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}