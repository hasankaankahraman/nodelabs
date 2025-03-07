import 'package:flutter/material.dart';

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
          // Film posteri
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: screenWidth * 0.45,
              height: screenHeight * 0.25,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  producer,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenWidth * 0.035,
                  ),
                ),
              ],
            ),
          ),

          // Favori butonu
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.white,
              ),
              onPressed: onFavoriteToggle,
            ),
          ),
        ],
      ),
    );
  }
}
