import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../widgets/custom_button.dart';

class UserProfileWidget extends StatelessWidget {
  final UserModel user;
  final VoidCallback onPhotoUpload;

  const UserProfileWidget({Key? key, required this.user, required this.onPhotoUpload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 1,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profil Fotoğrafı (Genişliğin %20'si)
          Container(
            width: screenWidth * 0.2,
            alignment: Alignment.centerLeft,
            child: CircleAvatar(
              radius: screenWidth * 0.08,
              backgroundImage: NetworkImage(user.photoUrl),
              backgroundColor: Colors.grey.shade800,
            ),
          ),

          // Kullanıcı Bilgileri (Genişliğin %30'u)
          Container(
            width: screenWidth * 0.25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                Text(
                  "ID: ${user.id}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenWidth * 0.03,
                  ),
                ),
              ],
            ),
          ),

          // Boşluk ekleyelim ki sıkışmasın
          SizedBox(width: screenWidth * 0.05),

          // "Fotoğraf Ekle" Butonu (CustomButton Kullanıldı)
          Container(
            width: screenWidth * 0.3,
            alignment: Alignment.center,
            child: CustomButton(
              text: "Fotoğraf Ekle",
              onPressed: onPhotoUpload,
              color: Colors.red,
              textColor: Colors.white,
              fontSize: screenWidth * 0.03,
              paddingHorizontal: screenWidth * 0.04,
              paddingVertical: screenHeight * 0.012,
              borderRadius: screenWidth * 0.03,
            ),
          ),
        ],
      ),
    );
  }
}
