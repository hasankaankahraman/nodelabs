import 'package:flutter/material.dart';
import 'package:nodelabs/core/app_colors.dart';
import 'package:nodelabs/services/api_service.dart';
import 'package:nodelabs/widgets/LimitedOfferBottomSheet.dart';
import 'package:nodelabs/widgets/custom_button.dart';
import 'package:nodelabs/widgets/user_profile_widget.dart';
import 'package:nodelabs/widgets/fav_movie_widget.dart';
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Tüm veri yükleme işlemlerini birleştir
  void _loadData() {
    _loadFavoriteMovies();
    _userProfile = ApiService().getUserProfile(widget.userToken);
  }

  void _loadFavoriteMovies() {
    setState(() {
      _favoriteMovies = ApiService().getFavoriteMovies(widget.userToken);
    });
  }

  // Optimistik UI güncellemesi ile favori ekleme/çıkarma işlemi
  Future<void> _toggleFavorite(String movieId, int index, List<MovieModel> currentMovies) async {
    // Mevcut filmi kopyala ve optimistik güncelleme için local state'i hemen değiştir
    List<MovieModel> updatedMovies = List.from(currentMovies);
    updatedMovies.removeAt(index); // Filmi hemen kaldır

    setState(() {
      _isLoading = true;
      // Optimistik güncelleme: Local olarak filmleri güncelle
      _favoriteMovies = Future.value(updatedMovies);
    });

    try {
      // API çağrısını yap
      final response = await ApiService().toggleFavorite(movieId, widget.userToken);

      if (!response) {
        // Eğer API başarısız olursa, orijinal listeyi geri getir
        _loadFavoriteMovies();
      }
    } catch (e) {
      // Hata durumunda orijinal listeyi geri getir
      _loadFavoriteMovies();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Favori kaldırma işlemi başarısız: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showLimitedOfferBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return LimitedOfferBottomSheet();
      },
    );
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
                  onPressed: () => _showLimitedOfferBottomSheet(context),
                  text: 'Sınırlı Teklif',
                  color: AppColors.accent,
                  textColor: Colors.white,
                  iconPath: 'assets/gem_icon.svg',
                  fontSize: screenWidth * 0.03,
                  paddingHorizontal: screenWidth * 0.02,
                  paddingVertical: screenHeight * 0.01,
                  borderRadius: screenWidth * 0.1,
                  iconSize: screenHeight * 0.02,
                  minWidth: screenWidth * 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
          return Future.delayed(Duration(milliseconds: 1500));
        },
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kullanıcı Profil Bilgisi
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

              // Beğenilen Filmler Başlığı
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Beğendiğim Filmler",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_isLoading)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                      ),
                    ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              // Beğenilen Filmler Listesi
              Expanded(
                child: FutureBuilder<List<MovieModel>>(
                  future: _favoriteMovies,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting && !_isLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, color: Colors.red, size: 48),
                            SizedBox(height: 16),
                            Text(
                              'Bir hata oluştu: ${snapshot.error}',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _loadFavoriteMovies,
                              child: Text('Yeniden Dene'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite_border, color: Colors.grey, size: 64),
                            SizedBox(height: 16),
                            Text(
                              'Henüz favori filminiz yok.',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Film listesinden beğendiğiniz filmleri favorilere ekleyebilirsiniz.',
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    } else {
                      final favoriteMovies = snapshot.data!;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.55,
                        ),
                        itemCount: favoriteMovies.length,
                        itemBuilder: (context, index) {
                          final movie = favoriteMovies[index];
                          return FavMovieCard(
                            imageUrl: movie.posterUrl,
                            title: movie.title,
                            producer: movie.producer ?? "Bilinmeyen Yapımcı",
                            isFavorite: true, // Profil ekranında her zaman favori
                            onFavoriteToggle: () => _toggleFavorite(movie.id, index, favoriteMovies),
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
      ),
    );
  }
}