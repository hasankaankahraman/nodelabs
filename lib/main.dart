import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/core/cubits/auth_cubit/auth_cubit.dart';
import 'package:nodelabs/core/cubits/profile_photo_cubit/profile_cubit.dart';
import 'package:nodelabs/views/login_screen.dart';
import 'package:nodelabs/views/main_screen.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(), // ✅ AuthCubit burada en başta tanımlandı
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(), // ✅ Profil fotoğrafı için cubit eklendi
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
      home: AuthGate(), // ✅ Kullanıcının oturum durumuna göre yönlendirme
    );
  }
}

// 📌 Kullanıcının giriş yapıp yapmadığını kontrol eden Widget
class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return MainScreen(user: state.user); // ✅ Kullanıcı bilgisi MainScreen'e gönderildi
        } else {
          return LoginScreen(); // ✅ Kullanıcı giriş yapmadıysa login ekranı
        }
      },
    );
  }
}
