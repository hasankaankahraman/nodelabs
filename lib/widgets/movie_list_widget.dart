import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_cubit.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_state.dart';
import 'package:nodelabs/models/movie_model.dart';
import 'package:nodelabs/widgets/movie_card_widget.dart';

class MovieListWidget extends StatefulWidget {
  final String userToken;

  const MovieListWidget({Key? key, required this.userToken}) : super(key: key);

  @override
  _MovieListWidgetState createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  double _scrollThreshold = 200;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialMovies();
  }

  void _loadInitialMovies() async {
    context.read<MovieCubit>().fetchMovies(widget.userToken);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollThreshold && !_isLoadingMore) {
      _isLoadingMore = true;
      context.read<MovieCubit>().fetchMovies(widget.userToken, loadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        return _buildMovieList(state);
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
          Text('Filmler yükleniyor...'),
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
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _loadInitialMovies(),
            child: Text('Yeniden Dene'),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieList(MovieState state) {
    final movies = state is MovieLoaded ? state.movies : [];
    final hasMore = state is MovieLoaded ? state.hasMore : false;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          final metrics = notification.metrics;
          if (metrics.atEdge) {
            if (metrics.pixels == 0) {
              // Listenin başına ulaşıldı
            } else {
              // Listenin sonuna ulaşıldı
              if (hasMore && !_isLoadingMore) {
                context.read<MovieCubit>().fetchMovies(widget.userToken, loadMore: true);
              }
            }
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
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return _buildMovieItem(movies[index]);
        },
      ),
    );
  }

  Widget _buildMovieItem(MovieModel movie) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: MovieCardWidget(
        movie: movie,
        isFavorite: movie.isFavorite,
        userToken: widget.userToken,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}