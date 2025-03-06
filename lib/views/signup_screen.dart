import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/core/cubits/auth_cubit/auth_cubit.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import 'login_screen.dart';
import 'profile_photo_screen.dart';
import 'home_screen.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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
                // Kullanıcının profil fotoğrafı var mı kontrolü
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
                  Text(
                    "Hoşgeldiniz",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Tempus varius a vitae interdum id\ntortor elementum tristique eleifend at.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                  SizedBox(height: 20),

                  // Ad Soyad Alanı
                  CustomTextField(
                    hintText: "Ad Soyad",
                    leftIconPath: "assets/adduser_icon.svg",
                    controller: nameController,
                  ),
                  SizedBox(height: 15),

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
                  SizedBox(height: 15),

                  // Şifre Tekrar Alanı
                  CustomTextField(
                    hintText: "Şifre Tekrar",
                    leftIconPath: "assets/unlock_icon.svg",
                    isPassword: true,
                    controller: confirmPasswordController,
                  ),
                  SizedBox(height: 15),

                  // Kullanıcı Sözleşmesi
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Kullanıcı sözleşmesini ",
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Sözleşme açıldı.");
                        },
                        child: Text(
                          "okudum ve kabul ediyorum.",
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Kayıt Ol Butonu
                  CustomButton(
                    text: state is AuthLoading ? "Kayıt Olunuyor..." : "Şimdi Kaydol",
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty &&
                          confirmPasswordController.text.isNotEmpty) {
                        if (passwordController.text == confirmPasswordController.text) {
                          context.read<AuthCubit>().signup(
                            nameController.text,
                            emailController.text,
                            passwordController.text,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Şifreler uyuşmuyor!", style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
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

                  // Giriş Yap (Yönlendirme ve Renk Güncellendi)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Zaten bir hesabın var mı?", style: TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text("Giriş Yap!", style: TextStyle(color: Colors.white)), // 📌 Metin rengi beyaz yapıldı
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
