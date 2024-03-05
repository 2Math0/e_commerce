import 'package:dio/dio.dart';
import 'package:e_commerce/data/conncetivity.dart';
import 'package:e_commerce/domain/product.dart';
import 'package:e_commerce/widgets/error_dialog.dart';
import 'package:flutter/material.dart';

class ApiService{
  final Dio dio;
  final ConnectivityService connectivityService;

  ApiService(this.dio, this.connectivityService);

  Future<void> _handleApiCall(
      Future<void> Function() apiCall, BuildContext context) async {
    try {
      if (await connectivityService.isOnline()) {
        await apiCall();
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 0,
            statusMessage: 'No internet connection',
          ),
        );
      }
    } on DioException catch (e) {
      if (context.mounted) {
        await DialogHelper.showErrorDialog(
            context, e.message ?? 'An error occurred');
      }
    } catch (e) {
      if (context.mounted) {
        await DialogHelper.showErrorDialog(context, 'An error occurred');
      }
    }
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await dio.get(AppApis.productsApi);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Failed to load products: $error');
    }
  }
}

class AppApis {
  static const String productsApi = 'https://fakestoreapi.com/products';
}
