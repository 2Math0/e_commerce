import 'package:e_commerce/bloc/product/bloc.dart';
import 'package:e_commerce/domain/product.dart';
import 'package:e_commerce/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    // Get the ProductBloc instance
    final productBloc = BlocProvider.of<ProductBloc>(context);

    // Dispatch the LoadProducts event only if the state is ProductInitial
    if (productBloc.state is ProductInitial) {
      productBloc.add(const LoadProducts());
      _availableCategories = _getAllCategories();
    }
    super.initState();
  }

  final TextEditingController _searchController = TextEditingController();
  List<String> _availableCategories = [];
  List<String> _selectedCategories = ['All'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchBar();
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (String value) {
              _toggleCategory(value);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'All',
                  child: ListTile(
                    title: const Text('All'),
                    leading: Icon(
                      _selectedCategories.contains('All')
                          ? Icons.check
                          : Icons.circle,
                    ),
                  ),
                ),
                for (String category in _availableCategories)
                  PopupMenuItem<String>(
                    value: category,
                    child: ListTile(
                      title: Text(category),
                      leading: Icon(
                        _selectedCategories.contains(category)
                            ? Icons.check
                            : Icons.circle,
                      ),
                    ),
                  ),
              ];
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductsLoaded) {
            if (state.products.isEmpty) {
              return const Center(child: Text('No Products Available'));
            }
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ProductItem(product: product);
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  void _showSearchBar() {
    showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (String value) {
                Navigator.pop(context); // Close the modal sheet
                _applySearchAndFilter();
              },
            ),
          ),
        );
      },
    );
  }

  void _toggleCategory(String category) {
    setState(() {
      if (category == 'All') {
        _selectedCategories = ['All'];
      } else {
        if (_selectedCategories.contains(category)) {
          _selectedCategories.remove(category);
          if (_selectedCategories.isEmpty) {
            _selectedCategories = ['All'];
          }
        } else {
          _selectedCategories.add(category);
          if (_selectedCategories.contains('All')) {
            _selectedCategories.remove('All');
          }
        }
      }
    });
  }

  void _applySearchAndFilter() {
    BlocProvider.of<ProductBloc>(context).add(
      LoadProducts(
        searchTerm: _searchController.text,
        categories:
            _selectedCategories.contains('All') ? null : _selectedCategories,
      ),
    );
  }

  List<String> _getAllCategories() {
    final List<String> allCategories = [
      'All',
      'Electronics',
      'Clothing',
      'Books',
    ];
    // You may want to fetch dynamic categories from API here
    return allCategories;
  }
}
