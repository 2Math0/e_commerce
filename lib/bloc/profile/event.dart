part of 'bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class FetchProfile extends ProfileEvent {
  final User user;

  const FetchProfile(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateProfile extends ProfileEvent {
  final UserProfile user;
  final UserProfile updatedProfile;

  const UpdateProfile({required this.user, required this.updatedProfile});

  @override
  List<Object?> get props => [user, updatedProfile];
}
