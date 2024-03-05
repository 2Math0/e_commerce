import 'package:e_commerce/domain/product.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
            tag: 'productImage_${product.id}',
            child: Image.network(
              product.image,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '\$${product.price.toString()}',
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.green,
                  ),
                ),
                if (product.category != null) ...[
                  const SizedBox(height: 8.0),
                  Text(
                    'Category: ${product.category}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
                if (product.description != null) ...[
                  const SizedBox(height: 8.0),
                  Text(
                    'Description: ${product.description}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Favorite button
                    IconButton(
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,

                        // by id
                        // if id is in fav make it red if not make it white

                      ),
                      onPressed: () {
                        // add to fav prefs
                        // remove from fav prefs
                      },
                    ),
                    // Cart button
                    ElevatedButton(
                      onPressed: () {
                        _addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text('${product.title} added to cart'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text('Add to Cart'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList('cart') ?? [];
    cartItems.add(product.title);
    prefs.setStringList('cart', cartItems);
  }
}