import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FavMovieCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String producer;
  final VoidCallback onFavoriteToggle;
  final bool isFavorite;

  const FavMovieCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.producer,
    required this.onFavoriteToggle,
    required this.isFavorite,
  }) : super(key: key);

  @override
  _FavMovieCardState createState() => _FavMovieCardState();
}

class _FavMovieCardState extends State<FavMovieCard> with SingleTickerProviderStateMixin {
  // Animasyon için gerekli controller
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Animasyon controller'ını başlat
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // Kalp ikonu için ölçek animasyonu - daha yumuşak
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.3), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.3, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Parıltı efekti için opaklık animasyonu
    _opacityAnimation = Tween<double>(begin: 0.0, end: 0.8).animate(
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.45,
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Film posteri
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.imageUrl,
                  width: screenWidth * 0.45,
                  height: screenHeight * 0.26,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: screenWidth * 0.45,
                      height: screenHeight * 0.26,
                      color: Colors.grey[800],
                      child: Icon(Icons.movie, color: Colors.grey[600], size: 50),
                    );
                  },
                ),
              ),

              // Favori butonu (Sağ Üstte)
              Positioned(
                right: 8,
                top: 8,
                child: GestureDetector(
                  onTap: () {
                    // Animasyonu tetikle
                    _animationController.reset();
                    _animationController.forward();

                    // Favori durumu değiştir
                    widget.onFavoriteToggle();
                  },
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Arka plan
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                          ),

                          // Ana kalp ikonu
                          Transform.scale(
                            scale: _scaleAnimation.value,
                            child: SvgPicture.asset(
                              widget.isFavorite ? 'assets/fav_icon.svg' : 'assets/favnot_icon.svg',
                              width: screenWidth * 0.06,
                              height: screenWidth * 0.06,
                              color: widget.isFavorite ? Colors.red : Colors.white,
                            ),
                          ),

                          // Parıltı efekti
                          if (_animationController.isAnimating)
                            Opacity(
                              opacity: _opacityAnimation.value,
                              child: Container(
                                width: screenWidth * 0.08,
                                height: screenWidth * 0.08,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red.withOpacity(0.3),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.008),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Film Adı
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 4),

                // Yapımcı
                Text(
                  widget.producer,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: widget.producer == "Bilinmeyen Yapımcı" ? screenWidth * 0.03 : screenWidth * 0.035,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}