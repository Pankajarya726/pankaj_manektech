import 'package:com_pankaj_test/database/db_constant.dart';
import 'package:com_pankaj_test/ui/cart/bloc/cart_bloc.dart';
import 'package:com_pankaj_test/ui/cart/bloc/cart_event.dart';
import 'package:com_pankaj_test/ui/cart/bloc/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> cartList = [];
  String totalQty = "0";
  String grandTotal = "0";
  CartBloc cartBloc = CartBloc();

  @override
  void initState() {
    super.initState();
    cartBloc.add(GetCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cartBloc,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "My Cart",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state is GetCartState) {
              cartList = state.cart;
            }
            if (state is DeleteCartState) {
              cartList.removeAt(state.index);
            }
          },
          builder: (context, state) {
            return ListView.builder(
                itemCount: cartList.length,
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width * 0.33,
                          width: MediaQuery.of(context).size.width * 0.33,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                              image: DecorationImage(image: NetworkImage(cartList[index].productImage), fit: BoxFit.contain)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                cartList[index].productName,
                                style: const TextStyle(color: Colors.black, fontSize: 18),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Price",
                                    style: TextStyle(color: Colors.black, fontSize: 15),
                                  ),
                                  Text("\$ " + cartList[index].price),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Quantity",
                                    style: TextStyle(color: Colors.black, fontSize: 15),
                                  ),
                                  Text(cartList[index].qty.toString()),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                  onTap: () {
                                    cartBloc.add(DeleteProductEvent(index: index, productId: cartList[index].productId));
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(decoration: TextDecoration.underline, color: Colors.red),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  );
                });
          },
        ),
        bottomNavigationBar: Container(
            height: 50,
            color: Colors.lightBlueAccent,
            width: MediaQuery.of(context).size.width,
            child: BlocConsumer<CartBloc, CartState>(
              listener: (context, state) {
                if (state is GetTotalState) {
                  grandTotal = state.grandTotal;
                  totalQty = state.totalQty;
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Items : $totalQty"),
                      Text("Grand Total : $grandTotal"),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}
