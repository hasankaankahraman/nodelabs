import 'package:flutter/material.dart';
import 'package:nodelabs/services/api_service.dart';
import 'package:nodelabs/widgets/custom_button.dart';
import '../models/movie_model.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  final String userToken; // Token'ı parametre olarak alıyoruz

  const ProfileScreen({Key? key, required this.userToken}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<MovieModel>> _favoriteMovies;
  late Future<UserModel> _userProfile; // Kullanıcı profilini tutacak değişken

  @override
  void initState() {
    super.initState();
    _favoriteMovies = ApiService().getFavoriteMovies(widget.userToken); // Favori filmleri yükle
    _userProfile = ApiService().getUserProfile(widget.userToken); // Kullanıcı profilini API'den çek
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Ortaya hizaladık
          children: [
            Text(
              "Profil Detayı",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 10), // Butonla başlık arasına boşluk ekledik
            CustomButton(
              text: 'Sınırlı Teklif', // Butonu küçülttüm
              onPressed: () {
                print("Sınırlı teklif butonuna tıklandı!");
              },
              color: Colors.red,
              textColor: Colors.white,
              iconPath: 'assets/gem_icon.svg',
            ),
          ],
        ),
        centerTitle: true, // AppBar içeriğini ortaladık
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Kullanıcı profilini yükleyen FutureBuilder
            FutureBuilder<UserModel>(
              future: _userProfile,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Profil bilgisi yüklenirken hata oluştu: ${snapshot.error}', style: TextStyle(color: Colors.white));
                } else if (!snapshot.hasData) {
                  return Text('Profil bilgisi bulunamadı.', style: TextStyle(color: Colors.white));
                } else {
                  final user = snapshot.data!;
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.photoUrl), // API'den gelen profil resmi
                        backgroundColor: Colors.grey.shade800,
                      ),
                      SizedBox(height: 10),
                      Text(user.name, style: TextStyle(color: Colors.white, fontSize: 20)),
                      Text("ID: ${user.id}", style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  );
                }
              },
            ),
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
