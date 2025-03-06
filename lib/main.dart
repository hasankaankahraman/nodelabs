import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/core/cubits/auth_cubit/auth_cubit.dart';
import 'package:nodelabs/core/cubits/profile_photo_cubit/profile_cubit.dart';
import 'package:nodelabs/core/cubits/movie_cubit/movie_cubit.dart';
import 'package:nodelabs/repositories/movie_repository.dart';
import 'package:nodelabs/services/api_service.dart';
import 'package:nodelabs/views/login_screen.dart';
import 'package:nodelabs/views/main_screen.dart';

void main() {
  final ApiService apiService = ApiService();
  final MovieRepository movieRepository = MovieRepository(apiService: apiService);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(),
        ),
        BlocProvider<MovieCubit>(
          create: (context) => MovieCubit(movieRepository: movieRepository), // ✅ MovieRepository kullanıldı
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF2A2A2A),
        fontFamily: 'Poppins',
      ),
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return MainScreen(user: state.user);
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
