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

class _MovieCardWidgetState extends State<MovieCardWidget> with SingleTickerProviderStateMixin {
  // Local state for the favorite status
  late bool _isFavorite;

  // Animasyon için gerekli controller
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.movie.isFavorite;

    // Animasyon controller'ını başlat
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // Kalp ikonu için ölçek animasyonu
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.3), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.3, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Opsiyonel: Parıltı efekti için opaklık animasyonu
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

            // Kalp ikonu - animasyonlu
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
                child: GestureDetector(
                  onTap: () {
                    // Animasyonu tetikle
                    _animationController.reset();
                    _animationController.forward();

                    // Optimistik güncelleme için önce yerel durumu değiştir
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });

                    // Sonra sunucu durumunu güncelle
                    context.read<MovieCubit>().toggleMovieFavorite(widget.movie.id, widget.userToken);
                    print("⭐ Favori butonu tıklandı: ${widget.movie.title} - yeni durum: $_isFavorite");
                  },
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Ana kalp ikonu (ölçeklenecek)
                          Transform.scale(
                            scale: _isFavorite ? _scaleAnimation.value : 1.0,
                            child: SvgPicture.asset(
                              _isFavorite ? 'assets/fav_icon.svg' : 'assets/favnot_icon.svg',
                              color: _isFavorite ? Colors.white : Colors.white,
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}