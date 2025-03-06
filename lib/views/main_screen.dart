import 'package:flutter/material.dart';
import 'package:nodelabs/views/home_screen.dart';
import 'package:nodelabs/views/profile_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/user_model.dart';

class MainScreen extends StatefulWidget {
  final UserModel user; // ✅ Kullanıcı bilgisi parametre olarak alınıyor

  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(user: widget.user), // ✅ Film Listesi Ekranı
          ProfileScreen(user: widget.user), // ✅ Kullanıcı bilgisi ProfileScreen'e geçildi
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
