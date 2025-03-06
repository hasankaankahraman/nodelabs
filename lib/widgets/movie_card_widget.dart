import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class MovieCardWidget extends StatelessWidget {
  final MovieModel movie;

  const MovieCardWidget({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height, // 📌 Tam ekran yüksekliği
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 📌 Arka planda tam ekran poster
          Image.network(
            movie.posterUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset("assets/default_poster.png", fit: BoxFit.cover);
            },
          ),

          // 📌 Üzerine siyah bir degrade efekt ekle
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.9)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 📌 Filmin bilgilerini ekle
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  movie.title,
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  movie.description,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // 📌 Favori butonu sağ alt köşeye eklendi
          Positioned(
            bottom: 100,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.white, size: 30),
              onPressed: () {
                print("⭐ Favorilere eklendi: ${movie.title}");
              },
            ),
          ),
        ],
      ),
    );
  }
}
