import 'package:e_commerce/domain/api_service.dart';
import 'package:e_commerce/domain/product.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'state.dart';

part 'event.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ApiService api;

  ProductBloc({required this.api}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
  }

  void _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    Logger().i('load products');
    try {
      // Fetch all products from the API
      final allProducts = await api.fetchProducts();

      // Apply search and filter locally
      final filteredProducts = _applySearchAndFilter(allProducts, event.categories, event.searchTerm);

      emit(ProductsLoaded(filteredProducts));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  List<Product> _applySearchAndFilter(List<Product> products, List<String>? categories, String? searchTerm) {
    // Apply category filter
    if (categories != null && !categories.contains('All')) {
      products = products.where((product) => categories.contains(product.category)).toList();
    }

    // Apply search filter
    if (searchTerm != null && searchTerm.isNotEmpty) {
      products = products.where((product) => product.title.toLowerCase().contains(searchTerm.toLowerCase())).toList();
    }

    return products;
  }
}

