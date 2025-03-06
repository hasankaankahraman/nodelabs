import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nodelabs/core/cubits/profile_photo_cubit/profile_cubit.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../models/user_model.dart';
import '../views/home_screen.dart';
import '../widgets/custom_button.dart';
import '../core/app_colors.dart';

class ProfilePhotoScreen extends StatefulWidget {
  final UserModel user;

  const ProfilePhotoScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePhotoScreenState createState() => _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState extends State<ProfilePhotoScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _checkUserPhoto();
  }

  void _checkUserPhoto() {
    if (widget.user.photoUrl.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: widget.user)),
        );
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      // 📌 Fotoğrafı sıkıştır
      final compressedImage = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        pickedFile.path + "_compressed.jpg",
        quality: 20, // Kaliteyi düşür (0-100)
      );

      if (compressedImage != null) {
        setState(() {
          _imageFile = File(compressedImage.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => ProfileCubit(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              Spacer(),

              Text(
                "Profil Detayı",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                "Fotoğraflarınızı Yükleyin",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                "Profilinize bir fotoğraf ekleyerek tamamlayın.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
              SizedBox(height: 30),

              GestureDetector(
                onTap: () => _showImageSourceDialog(),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: _imageFile != null ? Colors.white : Colors.grey.shade800,
                      width: 2,
                    ),
                    image: _imageFile != null
                        ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _imageFile == null
                      ? Center(child: Icon(Icons.add, color: Colors.grey, size: 40))
                      : null,
                ),
              ),

              Spacer(),

              BlocConsumer<ProfileCubit, ProfileState>(
                listener: (context, state) {
                  if (state is ProfilePhotoUploaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("✅ Fotoğraf başarıyla yüklendi!")),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen(user: widget.user)),
                    );
                  } else if (state is ProfileError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error, style: TextStyle(color: Colors.white))),
                    );
                  }
                },
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: CustomButton(
                      text: state is ProfileLoading ? "Yükleniyor..." : "Devam Et",
                      onPressed: _imageFile != null
                          ? () {
                        context.read<ProfileCubit>().uploadProfilePhoto(
                          _imageFile!,
                          widget.user.token,
                        );
                      }
                          : () {},
                      color: _imageFile != null ? AppColors.accent : Colors.grey.shade800,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.socialButtonBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Fotoğraf Yükle",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.white),
                title: Text("Kameradan Çek", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.white),
                title: Text("Galeriden Seç", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
