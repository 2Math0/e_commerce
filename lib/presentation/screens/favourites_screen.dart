import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  /// After saving items in fav prefs by id
  /// show them here by id
  /// by retrieving products from Bloc builder
  ///

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: const Center(
        child: Text('Favorites Screen'),
      ),
    );
  }
}
