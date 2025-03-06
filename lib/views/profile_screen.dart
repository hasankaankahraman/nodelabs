import 'package:flutter/material.dart';
import 'package:nodelabs/services/api_service.dart';
import 'package:nodelabs/widgets/custom_button.dart';
import '../models/movie_model.dart';

class ProfileScreen extends StatefulWidget {
  final String userToken; // Token'ı parametre olarak alıyoruz

  const ProfileScreen({Key? key, required this.userToken}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<MovieModel>> _favoriteMovies;

  @override
  void initState() {
    super.initState();
    _favoriteMovies = ApiService().getFavoriteMovies(widget.userToken); // Favori filmleri yükle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Profil Detayı", style: TextStyle(color: Colors.white)),
        actions: [
          // Sınırlı Teklif butonu ve iconu
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CustomButton(
              text: 'Sınırlı Teklif',
              onPressed: () {
                print("Sınırlı teklif butonuna tıklandı!");
              },
              color: Colors.red, // Buton rengini kırmızı yapıyoruz
              textColor: Colors.white,
              iconPath: 'assets/gem_icon.svg', // Icon path'i burada tanımlıyoruz
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profil bilgileri
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://example.com/your_profile_image.png'),
              backgroundColor: Colors.grey.shade800,
            ),
            SizedBox(height: 10),
            Text("Ayça Aydoğan", style: TextStyle(color: Colors.white, fontSize: 20)),
            Text("ID: 245677", style: TextStyle(color: Colors.grey, fontSize: 16)),

            SizedBox(height: 20),

            // Beğenilen filmler başlığı
            Text(
              "Beğendiğim Filmler",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Favori filmleri gösterecek FutureBuilder
            FutureBuilder<List<MovieModel>>(
              future: _favoriteMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Bir hata oluştu: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('Henüz favori filminiz yok.', style: TextStyle(color: Colors.white));
                } else {
                  final favoriteMovies = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: favoriteMovies.length,
                      itemBuilder: (context, index) {
                        final movie = favoriteMovies[index];
                        return ListTile(
                          title: Text(
                            movie.title,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            movie.description,
                            style: TextStyle(color: Colors.white70),
                          ),
                          leading: Image.network(movie.posterUrl),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
