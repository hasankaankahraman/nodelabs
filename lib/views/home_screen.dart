import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_cubit.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_state.dart';
import 'package:nodelabs/models/movie_model.dart';
import 'package:nodelabs/widgets/bottom_nav_bar.dart';
import 'package:nodelabs/widgets/movie_card_widget.dart';
import 'package:nodelabs/views/profile_screen.dart';
import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  bool _isLoadingMore = false;
  double _scrollThreshold = 200;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieCubit>().fetchMovies(widget.user.token);
    });
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
      body: _selectedIndex == 0 ? _buildMovieList() : ProfileScreen(userToken: widget.user.token),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildMovieList() {
    return BlocConsumer<MovieCubit, MovieState>(
      listener: (context, state) {
        if (state is MovieError) {
          _isLoadingMore = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
        if (state is MovieLoaded) {
          _isLoadingMore = false;
        }
      },
      builder: (context, state) {
        if (state is MovieInitial || state is MovieLoading) {
          return _buildLoadingScreen();
        }
        if (state is MovieError) {
          return _buildErrorScreen(state.error);
        }
        return _buildMoviePageView(state);
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Filmler yükleniyor...', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildErrorScreen(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red, size: 50),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(error, textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.read<MovieCubit>().fetchMovies(widget.user.token),
            child: Text('Yeniden Dene'),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviePageView(MovieState state) {
    final movies = state is MovieLoaded ? state.movies : [];
    final hasMore = state is MovieLoaded ? state.hasMore : false;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          final metrics = notification.metrics;
          if (metrics.atEdge && metrics.pixels != 0 && hasMore && !_isLoadingMore) {
            _isLoadingMore = true;
            context.read<MovieCubit>().fetchMovies(widget.user.token, loadMore: true);
          }
        }
        return true;
      },
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: hasMore ? movies.length + 1 : movies.length,
        itemBuilder: (context, index) {
          if (index >= movies.length) {
            return Center(child: CircularProgressIndicator());
          }
          return MovieCardWidget(
            movie: movies[index],
            userToken: widget.user.token,
          );
        },
      ),
    );
  }
}
