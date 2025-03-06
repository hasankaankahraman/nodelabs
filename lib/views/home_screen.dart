import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_cubit.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_state.dart';
import '../widgets/movie_list_widget.dart';
import '../models/user_model.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<MovieCubit>().fetchMovies(user.token);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Keşfet", style: TextStyle(color: Colors.white)),
      ),
      body: BlocBuilder<MovieCubit, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MovieLoaded) {
            return MovieListWidget(userToken: user.token);
          } else if (state is MovieError) {
            return Center(child: Text(state.error, style: TextStyle(color: Colors.white)));
          } else {
            return Center(child: Text("Henüz film yok.", style: TextStyle(color: Colors.white)));
          }
        },
      ),
    );
  }
}
