import 'package:flutter/material.dart';
import 'package:nodelabs/services/api_service.dart';
import 'package:nodelabs/widgets/custom_button.dart';
import 'package:nodelabs/widgets/user_profile_widget.dart';
import '../models/movie_model.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  final String userToken;

  const ProfileScreen({Key? key, required this.userToken}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<MovieModel>> _favoriteMovies;
  late Future<UserModel> _userProfile;

  @override
  void initState() {
    super.initState();
    _favoriteMovies = ApiService().getFavoriteMovies(widget.userToken);
    _userProfile = ApiService().getUserProfile(widget.userToken);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(flex: 3, child: SizedBox()),

            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Profil Detayı",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  text: 'Sınırlı Teklif',
                  onPressed: () {
                    print("Sınırlı teklif butonuna tıklandı!");
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  iconPath: 'assets/gem_icon.svg',
                  fontSize: screenWidth * 0.03,
                  paddingHorizontal: screenWidth * 0.02,
                  paddingVertical: screenHeight * 0.01,
                  borderRadius: screenWidth * 0.1,
                  iconSize: screenHeight * 0.02,
                  minWidth: screenWidth * 0.3, // Butonun genişliği
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<UserModel>(
              future: _userProfile,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text(
                    'Profil bilgisi yüklenirken hata oluştu: ${snapshot.error}',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  );
                } else if (!snapshot.hasData) {
                  return Text('Profil bilgisi bulunamadı.', style: TextStyle(color: Colors.white));
                } else {
                  return UserProfileWidget(
                    user: snapshot.data!,
                    onPhotoUpload: () {
                      print("Fotoğraf Ekle butonuna tıklandı!");
                    },
                  );
                }
              },
            ),
            SizedBox(height: screenHeight * 0.03),

            Text(
              "Beğendiğim Filmler",
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            Expanded(
              child: FutureBuilder<List<MovieModel>>(
                future: _favoriteMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text(
                      'Bir hata oluştu: ${snapshot.error}',
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text(
                      'Henüz favori filminiz yok.',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index].title, style: TextStyle(color: Colors.white)),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
