import 'dart:ui';
import 'package:flutter/material.dart';

class LimitedOfferBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => Navigator.pop(context), // 📌 Blurlu alana dokununca kapansın
      child: Stack(
        children: [
          // 📌 Blur efektli arka plan
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Blur derecesi
            child: Container(
              color: Colors.black.withOpacity(0.5), // Hafif saydam karartma efekti
              width: screenWidth,
              height: screenHeight,
            ),
          ),

          // 📌 Bottom Sheet İçeriği
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {}, // 📌 İçeriğe dokununca kapanmasın
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.8, // %80 yükseklik
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    // 📌 Üstte ortada "çekme çubuğu" (stick)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // 📌 PNG görüntüsünü tam ekran genişliğinde kapla
                    Expanded(
                      child: Image.asset(
                        'assets/limited_offer.png',
                        width: double.infinity, // Tam genişlik
                        fit: BoxFit.cover, // Görüntüyü ekranı kaplayacak şekilde sığdır
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
