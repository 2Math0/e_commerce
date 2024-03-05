import 'package:e_commerce/app/app_routes.dart';
import 'package:e_commerce/bloc/authentication/bloc.dart';
import 'package:e_commerce/domain/auth_service.dart';
import 'package:e_commerce/widgets/auth_button.dart';
import 'package:e_commerce/widgets/txt_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushNamed(context, AppRoutes.navigation);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text(
                  'Join our E-commerce',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // username textfield
                CustomTextField(
                  controller: emailController,
                  hintText: 'Username',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 35),

                // sign up button
                AuthBtn(
                  onTap: () => signUp(
                    emailController.text,
                    passwordController.text,
                    context,
                  ),
                  title: 'Sign Up',
                ),

                // already a member
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, AppRoutes.authentication),
                      child: const Text(
                        'LogIn',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signUp(email, password, context) async {
    final user = await _authService.signUp(
      email: email,
      password: password,
    );

    if (user != null && context.mounted) {
      BlocProvider.of<AuthenticationBloc>(context).add(UserLoggedInEvent(user));
      Navigator.pushNamed(context, AppRoutes.navigation);
    }
  }
}
