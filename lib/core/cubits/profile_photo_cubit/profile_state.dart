part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfilePhotoUploaded extends ProfileState {
  final String photoUrl;

  ProfilePhotoUploaded(this.photoUrl);

  @override
  List<Object?> get props => [photoUrl];
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError(this.error);

  @override
  List<Object?> get props => [error];
}
