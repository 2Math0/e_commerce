import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:e_commerce/bloc/product/bloc.dart';
import 'package:e_commerce/presentation/screens/cart_screen.dart';
import 'package:e_commerce/presentation/screens/favourites_screen.dart';
import 'package:e_commerce/presentation/screens/product_list_screen.dart';
import 'package:e_commerce/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavWrapper extends StatefulWidget {
  const BottomNavWrapper({Key? key}) : super(key: key);

  @override
  BottomNavWrapperState createState() => BottomNavWrapperState();
}

class BottomNavWrapperState extends State<BottomNavWrapper> {
  int _currentIndex = 1;

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  /// use this snippet to change index from other classes
  /// final CurvedNavigationBarState? navBarState =
  //                         _bottomNavigationKey.currentState;
  //                     navBarState?.setPage(1);

  final List<Widget> _pages = [
    const ProfileScreen(),
    const ProductListScreen(),
    const FavoritesScreen(),
    const CartScreen(),
  ];

  @override
  void dispose() {
    BlocProvider.of<ProductBloc>(context).close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _currentIndex,
        color: Colors.black87,
        buttonBackgroundColor: Colors.black87,
        backgroundColor: Colors.transparent,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: 'Profile',
            labelStyle: TextStyle(color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.shop_2, color: Colors.green),
            label: 'Products',
            labelStyle: TextStyle(color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            label: 'Favorites',
            labelStyle: TextStyle(color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.shopping_cart,
              color: Colors.cyan,
            ),
            label: 'Cart',
            labelStyle: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
