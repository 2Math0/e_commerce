part of 'bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLoaded extends ProfileState {
  final UserProfile userProfile;

  const ProfileLoaded(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

class ProfileUpdated extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileError extends ProfileState {
  final String error;

  const ProfileError({required this.error});

  @override
  List<Object?> get props => [error];
}
