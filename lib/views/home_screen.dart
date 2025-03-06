import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_cubit.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_state.dart';
import '../widgets/movie_list_widget.dart';
import '../models/user_model.dart';
import 'package:nodelabs/widgets/bottom_nav_bar.dart';
import 'package:nodelabs/views/profile_screen.dart'; // Profile ekranı import ettik

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Filmleri yüklemek için MovieCubit'i çağırıyoruz
    Future.microtask(() {
      context.read<MovieCubit>().fetchMovies(widget.user.token);
    });

    // Sayfaları tanımlıyoruz
    _pages = [
      BlocProvider.value(
        value: context.read<MovieCubit>(),
        child: MovieListWidget(
          userToken: widget.user.token, // MovieListWidget'a userToken parametresi geçiyoruz
        ),
      ),
      ProfileScreen(
        userToken: widget.user.token, // userToken parametresini doğru şekilde geçiriyoruz
      ),
    ];
  }

  // Alt nav bar tıklama işlemi
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Seçilen sayfaya geçiş
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Sayfa içeriği seçili index'e göre gösterilir

      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex, // Seçili index
        onItemTapped: _onItemTapped, // Alt nav bar tıklama işlemi
      ),
    );
  }
}
