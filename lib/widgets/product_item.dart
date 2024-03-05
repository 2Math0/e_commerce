import 'package:e_commerce/domain/product.dart';
import 'package:e_commerce/presentation/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      margin: const EdgeInsets.all(8.0),
      elevation: 5.0,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Hero(
              tag: 'productImage_${product.id}',
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16.0)),
                child: CachedNetworkImage(
                  imageUrl: product.image,
                  height: 90,
                  width: 90,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    product.title,
                    overflow: TextOverflow.clip,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '\$${product.price.toString()}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8.0),

                ],
              ),
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Favorite button
                IconButton(
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    // Handle favorite button tap
                  },
                ),
                // Cart button
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    _addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.title} added to cart'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList('cart') ?? [];
    cartItems.add(product.title);
    prefs.setStringList('cart', cartItems);
  }

  void _addToFavourite(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favItems = prefs.getStringList('fav') ?? [];
    favItems.add(product.title);
    prefs.setStringList('fav', favItems);
  }
}
