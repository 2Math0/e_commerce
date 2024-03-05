import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import '../presentation/screens/profile_screen.dart';

class FirestoreService {
  final CollectionReference userProfileCollection =
      FirebaseFirestore.instance.collection('user_profiles');

  Future<UserProfile> getUserProfile(String userId) async {
    try {
      final DocumentSnapshot snapshot =
          await userProfileCollection.doc(userId).get();

      if (snapshot.exists) {
        final userProfileData = snapshot.data()! as Map<String, dynamic>;
        return UserProfile(
          userId: userId,
          name: userProfileData['name'],
          lastName: userProfileData['lastName'],
          address: userProfileData['address'],
          age: userProfileData['age'],
          city: userProfileData['city'],
          country: userProfileData['country'],
        );
      } else {
        throw Exception('User profile not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  Future<void> updateProfile(UserProfile userProfile) async {
    try {
      await userProfileCollection.doc(userProfile.userId).set({
        'name': userProfile.name,
        'lastName': userProfile.lastName,
        'address': userProfile.address,
        'age': userProfile.age,
        'city': userProfile.city,
        'country': userProfile.country,
      });
    } catch (e) {
      Logger().e(e);
    }
  }
}
