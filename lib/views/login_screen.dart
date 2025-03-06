import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/core/cubits/auth_cubit/auth_cubit.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_social_button.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'profile_photo_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 350,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(25),
          ),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                if (state.user.photoUrl.isEmpty) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePhotoScreen(user: state.user)),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen(user: state.user)),
                  );
                }
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error, style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Text("Merhabalar", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 5),
                  Text(
                    "Tempus varius a vitae interdum id\ntortor elementum tristique eleifend at.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                  SizedBox(height: 20),

                  // E-Posta Alanı
                  CustomTextField(
                    hintText: "E-Posta",
                    leftIconPath: "assets/letter_icon.svg",
                    controller: emailController,
                  ),
                  SizedBox(height: 15),

                  // Şifre Alanı
                  CustomTextField(
                    hintText: "Şifre",
                    leftIconPath: "assets/unlock_icon.svg",
                    isPassword: true,
                    controller: passwordController,
                  ),
                  SizedBox(height: 10),

                  // Şifremi Unuttum
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Şifremi unuttum",
                        style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Giriş Yap Butonu
                  CustomButton(
                    text: state is AuthLoading ? "Giriş Yapılıyor..." : "Giriş Yap",
                    onPressed: () {
                      if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                        context.read<AuthCubit>().login(
                          emailController.text,
                          passwordController.text,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Lütfen tüm alanları doldurun.", style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),

                  // Sosyal Medya Butonları
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomSocialButton(
                        iconPath: "assets/google_icon.svg",
                        onPressed: () => print("Google ile giriş yapıldı"),
                      ),
                      SizedBox(width: 15),
                      CustomSocialButton(
                        iconPath: "assets/apple_icon.svg",
                        onPressed: () => print("Apple ile giriş yapıldı"),
                      ),
                      SizedBox(width: 15),
                      CustomSocialButton(
                        iconPath: "assets/facebook_icon.svg",
                        onPressed: () => print("Facebook ile giriş yapıldı"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Kayıt Ol (Yönlendirme ve Renk Güncellendi)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Bir hesabın yok mu?", style: TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignupScreen()),
                          );
                        },
                        child: Text("Kayıt Ol!", style: TextStyle(color: Colors.white)), // 📌 Metin rengi beyaz yapıldı
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
