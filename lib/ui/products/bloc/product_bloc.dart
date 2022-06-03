import 'package:com_pankaj_test/database/database_helper.dart';
import 'package:com_pankaj_test/database/db_constant.dart';
import 'package:com_pankaj_test/model/product_response.dart';
import 'package:com_pankaj_test/ui/products/bloc/product_event.dart';
import 'package:com_pankaj_test/ui/products/bloc/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductRepository _repository = ProductRepository();

  ProductBloc() : super(ProductInitState()) {
    on<LoadProductEvent>(loadProduct);
    on<GetCartEvent>(getCartCount);
  }

  loadProduct(LoadProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState());
    Map<String, dynamic> input = {"page": event.pageNo, "perPage": event.pageSize};

    ProductResponse response = await _repository.getProduct(input);
    if (response.status == 200) {
      emit(GetProductState(products: response.data));
    } else {
      emit(GetProductFailerState(msg: response.message));
    }
  }

  getCartCount(GetCartEvent event, Emitter<ProductState> emit) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    List<Cart> cartList = await databaseHelper.getCart();
    emit(GetCartCountState(count: cartList.length));
  }
}
