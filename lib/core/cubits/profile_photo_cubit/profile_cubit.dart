import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://caseapi.nodelabs.dev/user"));

  ProfileCubit() : super(ProfileInitial());

  Future<void> uploadProfilePhoto(File imageFile, String token) async {
    emit(ProfileLoading());

    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path, filename: "profile.jpg"),
      });

      final response = await _dio.post(
        "/upload_photo",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200 && response.data['response']['code'] == 200) {
        final String newPhotoUrl = response.data["data"]["photoUrl"];
        emit(ProfilePhotoUploaded(newPhotoUrl));
      } else {
        emit(ProfileError("🚨 Fotoğraf yüklenirken hata oluştu!"));
      }
    } catch (e) {
      emit(ProfileError("❌ Hata: $e"));
    }
  }
}
