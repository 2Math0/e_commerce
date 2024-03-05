import 'package:e_commerce/domain/firestore_service.dart';
import 'package:e_commerce/presentation/screens/profile_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'event.dart';

part 'state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirestoreService fireStoreService;

  ProfileBloc(this.fireStoreService) : super(ProfileInitial()) {
    on<UpdateProfile>(_mapUpdateProfileToState);
    on<FetchProfile>(_mapFetchProfileToState);
  }

  void _mapFetchProfileToState(
      FetchProfile event, Emitter<ProfileState> emit) async {
    try {
      final userProfile = await fireStoreService.getUserProfile(event.user.uid);
      emit(ProfileLoaded(userProfile));
    } catch (e) {
      emit(ProfileError(error: 'Failed to fetch profile: $e'));
    }
  }

  void _mapUpdateProfileToState(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    try {
      Logger().i('updating');
      // Get the user's ID from Firebase Authentication
      final userId = event.user.userId;

      // Create a UserProfile object
      final updatedProfile = UserProfile(
        userId: userId,
        name: event.updatedProfile.name,
        lastName: event.updatedProfile.lastName,
        address: event.updatedProfile.address,
        age: event.updatedProfile.age,
        city: event.updatedProfile.city,
        country: event.updatedProfile.country,
      );

      // Update the user's profile in Firestore
      await fireStoreService.updateProfile(updatedProfile);

      emit(ProfileUpdated());
    } catch (e) {
      emit(ProfileError(error: e.toString()));
    }
  }
}
