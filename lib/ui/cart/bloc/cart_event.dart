import 'package:equatable/equatable.dart';

class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCartEvent extends CartEvent {
  GetCartEvent();
}

class DeleteProductEvent extends CartEvent {
  final String productId;
  final int index;

  DeleteProductEvent({required this.productId, required this.index});

  @override
  List<Object?> get props => [productId, index];
}
