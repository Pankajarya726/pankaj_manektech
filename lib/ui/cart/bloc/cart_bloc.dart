import 'package:com_pankaj_test/database/database_helper.dart';
import 'package:com_pankaj_test/database/db_constant.dart';
import 'package:com_pankaj_test/ui/cart/bloc/cart_event.dart';
import 'package:com_pankaj_test/ui/cart/bloc/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitState()) {
    on<GetCartEvent>(getCart);
    on<DeleteProductEvent>(remoteProduct);
  }

  getCart(GetCartEvent event, Emitter<CartState> emit) async {
    List<Cart> cart = await DatabaseHelper().getCart();
    Map<String, dynamic> total = await DatabaseHelper().getTotalItemCount();

    String totalQty = total["total_qty"].toString();
    String grandTotal = total["grand_total"].toString();

    emit(GetCartState(cart: cart));
    emit(GetTotalState(grandTotal: grandTotal, totalQty: totalQty));
  }

  remoteProduct(DeleteProductEvent event, Emitter<CartState> emit) async {
    await DatabaseHelper().deleteProductFromCart(event.productId);
    emit(DeleteCartState(index: event.index));
    Map<String, dynamic> total = await DatabaseHelper().getTotalItemCount();

    String totalQty = total["total_qty"].toString();
    String grandTotal = total["grand_total"].toString();
    emit(GetTotalState(grandTotal: grandTotal, totalQty: totalQty));
  }
}
