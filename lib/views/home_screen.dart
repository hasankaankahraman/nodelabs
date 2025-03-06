import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_cubit.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_state.dart';
import '../widgets/movie_list_widget.dart';
import '../models/user_model.dart';
import 'package:nodelabs/widgets/bottom_nav_bar.dart';
import 'package:nodelabs/views/profile_screen.dart';

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

    Future.microtask(() {
      context.read<MovieCubit>().fetchMovies(widget.user.token);
    });

    _pages = [
      BlocProvider.value(
        value: context.read<MovieCubit>(),
        child: MovieListWidget(
          userToken: widget.user.token, // 🔥 Eksik parametre eklendi
        ),
      ),
      ProfileScreen(user: widget.user),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          _selectedIndex == 0 ? "Keşfet" : "Profil",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _pages[_selectedIndex],

      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
