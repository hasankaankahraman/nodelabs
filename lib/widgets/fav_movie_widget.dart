import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FavMovieCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.45, // Kart genişliği
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Stack ile resim ve kalp butonunu üst üste koyuyoruz
          Stack(
            children: [
              // 🎬 Film posteri
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: screenWidth * 0.45,
                  height: screenHeight * 0.26, // 🔥 Biraz küçülttük
                  fit: BoxFit.cover,
                ),
              ),

              // ❤️ Favori butonu (Sağ Üstte)
              Positioned(
                right: 6,
                top: 6,
                child: GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      isFavorite ? 'assets/fav_icon.svg' : 'assets/favnot_icon.svg',
                      width: screenWidth * 0.06,
                      height: screenWidth * 0.06,
                    ),
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
                // 🎬 Film Adı
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 4), // 🔥 Boşluğu azalttık

                // 🎭 Yapımcı (Bilinmeyen ise daha küçük yazı boyutu)
                Text(
                  producer,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: producer == "Bilinmeyen Yapımcı" ? screenWidth * 0.03 : screenWidth * 0.035, // 🔥 Küçük font
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
