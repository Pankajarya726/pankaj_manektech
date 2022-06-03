import 'package:equatable/equatable.dart';

class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProductEvent extends ProductEvent {
  final int pageNo;
  final int pageSize;

  LoadProductEvent({required this.pageNo, required this.pageSize});

  @override
  List<Object?> get props => [pageNo, pageSize];
}

class GetCartEvent extends ProductEvent {
  GetCartEvent();
}
