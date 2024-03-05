part of 'bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {
  final List<String>? categories;
  final String? searchTerm;

  const LoadProducts({
    this.categories,
    this.searchTerm,
  });
}

