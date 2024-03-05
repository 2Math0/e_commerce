import 'package:e_commerce/app/app_routes.dart';
import 'package:e_commerce/bloc/profile/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/bloc/authentication/bloc.dart';

class UserProfile {
  String name;
  String lastName;
  String address;
  int age;
  String city;
  String country;

  UserProfile({
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

  @override
  void initState() {
    super.initState();

    // Get the ProductBloc instance
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    // Dispatch the Authentication event only if the state is ProductInitial
    if (authBloc.state is AuthenticationInitial) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        authBloc.add(UserLoggedInEvent(currentUser));
      } else {
        authBloc.add(UserLoggedOutEvent());
      }
    }

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
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return _buildProfileContent(context, state.user);
          } else if (state is AuthenticationInitial) {
            return const Center(child: CircularProgressIndicator());
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showSignInDialog(context);
            });
            return _buildNonAuthenticatedContent();
          }
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${user.displayName}!',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Edit Your Profile:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildTextField('Name', _nameController),
          _buildTextField('Last Name', _lastNameController),
          _buildTextField('Address', _addressController),
          _buildTextField('Age', _ageController),
          _buildTextField('City', _cityController),
          _buildTextField('Country', _countryController),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _updateUserProfile(context, user);
            },
            child: const Text('Update Profile'),
          ),
        ],
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

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _updateUserProfile(BuildContext context, User user) {
    // Retrieve user input from controllers
    final String name = _nameController.text;
    final String lastName = _lastNameController.text;
    final String address = _addressController.text;
    final int age = int.tryParse(_ageController.text) ?? 0;
    final String city = _cityController.text;
    final String country = _countryController.text;

    // Create a UserProfile object with the updated data
    final updatedProfile = UserProfile(
      name: name,
      lastName: lastName,
      address: address,
      age: age,
      city: city,
      country: country,
    );

    // Dispatch an event to update the user's profile
    // You'll need to implement a ProfileBloc for this functionality
    // and dispatch an event like UpdateProfile(updatedProfile)
    // BlocProvider.of<ProfileBloc>(context).add(UpdateProfile(updatedProfile));
  }
}
