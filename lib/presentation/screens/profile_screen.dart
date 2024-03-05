import 'package:e_commerce/app/app_routes.dart';
import 'package:e_commerce/bloc/profile/bloc.dart';
import 'package:e_commerce/widgets/auth_button.dart';
import 'package:e_commerce/widgets/txt_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/bloc/authentication/bloc.dart';
import 'package:logger/logger.dart';

class UserProfile {
  String userId;
  String name;
  String lastName;
  String address;
  int age;
  String city;
  String country;

  UserProfile({
    required this.userId,
    required this.name,
    required this.lastName,
    required this.address,
    required this.age,
    required this.city,
    required this.country,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _addressController;
  late TextEditingController _ageController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;

  final GlobalKey<ScaffoldState> profileKey = GlobalKey<ScaffoldState>();
  late AuthenticationBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthenticationBloc>(context);
    // Initialize controllers with empty values
    _nameController = TextEditingController();
    _lastNameController = TextEditingController();
    _addressController = TextEditingController();
    _ageController = TextEditingController();
    _cityController = TextEditingController();
    _countryController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: profileKey,
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationInitial) {
            Logger().i('user');
            try {
              authBloc.add(const AuthCheckRequested());
            } catch (e) {
              Logger().e(e);
            }
            return const Center(child: CircularProgressIndicator());
          } else if (state is Authenticated) {
            Logger().i('authenticated');
            return BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  // Display the profile data in the UI
                  final UserProfile userProfile = state.userProfile;
                  _nameController.text = userProfile.name;
                  _lastNameController.text = userProfile.lastName;
                  _addressController.text = userProfile.address;
                  _ageController.text = userProfile.age.toString();
                  _cityController.text = userProfile.city;
                  _countryController.text = userProfile.country;

                  return _buildProfileContent(context, userProfile);
                } else if (state is ProfileError) {
                  // Handle error state
                  return Center(child: Text('Error: ${state.error}'));
                } else if (state is ProfileInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  // Handle other states if needed
                  return const SizedBox.shrink();
                }
              },
            );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showSignInDialog(context);
            });
            return _buildNonAuthenticatedContent();
          }
        },
        listener: (BuildContext context, AuthenticationState state) {
          final user = (authBloc.state as Authenticated).user;
          BlocProvider.of<ProfileBloc>(context).add(FetchProfile(user));
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserProfile user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Welcome, ${user.name}!',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Edit Your Profile:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(hintText: 'Name', controller: _nameController),
            CustomTextField(
                hintText: 'Last Name', controller: _lastNameController),
            CustomTextField(
                hintText: 'Address', controller: _addressController),
            CustomTextField(hintText: 'Age', controller: _ageController),
            CustomTextField(hintText: 'City', controller: _cityController),
            CustomTextField(
                hintText: 'Country', controller: _countryController),
            const SizedBox(height: 16),
            AuthBtn(
              onTap: () => _updateUserProfile(context, user),
              title: 'Update Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNonAuthenticatedContent() {
    return Center(
      child: TextButton(
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.authentication),
          child: const Text('Please sign in to access your profile.')),
    );
  }

  void _showSignInDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Sign In Required'),
          content: const Text('Please sign in to access your profile.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                Navigator.pushNamed(context, AppRoutes.authentication);
              },
              child: const Text('Sign In'),
            ),
          ],
        );
      },
    );
  }

  void _updateUserProfile(BuildContext context, UserProfile user) {
    // Retrieve user input from controllers
    final String name = _nameController.text;
    final String lastName = _lastNameController.text;
    final String address = _addressController.text;
    final int age = int.tryParse(_ageController.text) ?? 0;
    final String city = _cityController.text;
    final String country = _countryController.text;

    // Create a UserProfile object with the updated data
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Update the user profile in Firestore using the user ID
    final updatedProfile = UserProfile(
      name: name,
      lastName: lastName,
      address: address,
      age: age,
      city: city,
      country: country,
      userId: userId,
    );

    BlocProvider.of<ProfileBloc>(context)
        .add(UpdateProfile(user: user, updatedProfile: updatedProfile));
  }
}
