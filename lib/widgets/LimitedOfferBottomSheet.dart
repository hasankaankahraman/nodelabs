import 'package:flutter/material.dart';

class LimitedOfferBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width, // Ekranın tamamını kapla
      height: MediaQuery.of(context).size.height * 0.8, // %70 yükseklik
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Üstte ortada "çekme çubuğu" (stick)
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

          // PNG görüntüsünü tam ekran genişliğinde kapla
          Expanded(
            child: Image.asset(
              'assets/limited_offer.png',
              width: double.infinity, // Tam genişlik
              fit: BoxFit.cover, // Görüntüyü ekranı kaplayacak şekilde sığdır
            ),
          ),
        ],
      ),
    );
  }
}
