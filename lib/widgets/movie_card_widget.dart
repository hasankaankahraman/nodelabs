import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class MovieCardWidget extends StatelessWidget {
  final MovieModel movie;

  const MovieCardWidget({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📌 Film Posteri
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              movie.posterUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print("⚠️ Hata: Poster yüklenemedi, varsayılan gösteriliyor -> ${movie.posterUrl}");
                return Image.asset(
                  "assets/default_poster.png", // ✅ Eğer resim yüklenemezse, varsayılan bir resim göster
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📌 Film Başlığı ve Favori Butonu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        movie.title,
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite_border, color: Colors.white),
                      onPressed: () {
                        print("⭐ Favorilere eklendi: ${movie.title}");
                      },
                    ),
                  ],
                ),
                SizedBox(height: 5),

                // 📌 Açıklama
                Text(
                  movie.description,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
