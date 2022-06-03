import 'package:com_pankaj_test/database/db_constant.dart';
import 'package:equatable/equatable.dart';

class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitState extends CartState {}

class GetCartState extends CartState {
  final List<Cart> cart;

  GetCartState({required this.cart});

  @override
  List<Object?> get props => [cart];
}

class GetTotalState extends CartState {
  final String totalQty;
  final String grandTotal;

  GetTotalState({required this.totalQty, required this.grandTotal});

  @override
  List<Object?> get props => [totalQty, grandTotal];
}

class DeleteCartState extends CartState {
  final int index;

  DeleteCartState({required this.index});

  @override
  List<Object?> get props => [index];
}
