import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {

  /// After saving items in cart prefs by id
  /// show them here by id and count
  /// by retrieving products from Bloc builder
  /// add delete functionality
  ///
  ///
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: const Center(
        child: Text('Cart Screen'),
      ),
    );
  }
}
