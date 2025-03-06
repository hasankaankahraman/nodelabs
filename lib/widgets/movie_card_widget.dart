import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nodelabs/core/app_colors.dart';
import '../models/movie_model.dart';
import '../services/api_service.dart';

class MovieCardWidget extends StatefulWidget {
  final MovieModel movie;
  final bool isFavorite;
  final String userToken;  // Token'ı parametre olarak alıyoruz

  const MovieCardWidget({
    Key? key,
    required this.movie,
    required this.isFavorite,
    required this.userToken,  // Token'ı parametre olarak alıyoruz
  }) : super(key: key);

  @override
  _MovieCardWidgetState createState() => _MovieCardWidgetState();
}

class _MovieCardWidgetState extends State<MovieCardWidget> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  // Favori durumunu değiştirme
  void _toggleFavorite() async {
    try {
      final success = await ApiService().toggleFavorite(widget.movie.id, widget.userToken);  // 2 parametreyi geçiyoruz
      if (success) {
        setState(() {
          _isFavorite = !_isFavorite;
        });
        print("⭐ Favorilere eklendi/çıkarıldı: ${widget.movie.title}");
      }
    } catch (e) {
      print("Error: $e");
      // Hata durumunda kullanıcıya bildirim yapabilirsiniz.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            bottom: 20,  // Yukarıya biraz kaydırdık
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
            top: MediaQuery.of(context).size.height / 2 - 25,  // Ekranın ortasına yerleştiriyoruz
            right: 20,
            child: Container(
              height: 80,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.rectangle,  // Dikdörtgen şekli
                borderRadius: BorderRadius.circular(50),  // Yuvarlak köşeler
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: IconButton(
                icon: SvgPicture.asset(
                  _isFavorite ? 'assets/fav_icon.svg' : 'assets/favnot_icon.svg',
                  color: Colors.white,
                  width: 50,  // İkonun boyutunu büyüttük
                  height: 50,
                ),
                onPressed: _toggleFavorite,  // Favori işlemi
              ),
            ),
          ),
        ],
      ),
    );
  }
}
