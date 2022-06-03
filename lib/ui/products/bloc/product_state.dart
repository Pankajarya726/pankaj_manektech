import 'package:com_pankaj_test/model/product_response.dart';
import 'package:equatable/equatable.dart';

class ProductState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ProductInitState extends ProductState {}

class ProductLoadingState extends ProductState {}

class GetProductState extends ProductState {
  final List<ProductModel> products;

  GetProductState({required this.products});

  @override
  List<Object?> get props => [products];
}

class GetCartCountState extends ProductState {
  final int count;

  GetCartCountState({required this.count});

  @override
  List<Object?> get props => [count];
}

class GetProductFailerState extends ProductState {
  final String msg;

  GetProductFailerState({required this.msg});

  @override
  List<Object?> get props => [msg];
}
