import 'package:com_pankaj_test/database/database_helper.dart';
import 'package:com_pankaj_test/database/db_constant.dart';
import 'package:com_pankaj_test/model/product_response.dart';
import 'package:com_pankaj_test/ui/cart/cart_screen.dart';
import 'package:com_pankaj_test/ui/products/bloc/product_bloc.dart';
import 'package:com_pankaj_test/ui/products/bloc/product_event.dart';
import 'package:com_pankaj_test/ui/products/bloc/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final RefreshController _refreshController = RefreshController(initialRefresh: true);
  List<ProductModel> productList = [];
  int pageNo = 1;
  int pageSize = 5;
  int cartCount = 0;
  ProductBloc productBloc = ProductBloc();

  @override
  void initState() {
    super.initState();
    productBloc.add(LoadProductEvent(pageNo: pageNo, pageSize: pageSize));
  }

  @override
  void didUpdateWidget(covariant ProductScreen oldWidget) {
    debugPrint("_ProductScreenState");
    productBloc.add(GetCartEvent());
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductBloc>(
      create: (context) => productBloc,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Shopping Mall",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())).then((value) {
                      productList.clear();
                      pageNo = 1;
                      productBloc.add(LoadProductEvent(pageNo: pageNo, pageSize: pageSize));
                      // productBloc.add(GetCartEvent());
                    });
                  },
                  padding: EdgeInsets.zero,
                  splashRadius: 10,
                  icon: Stack(
                    children: [
                      const Icon(
                        Icons.shopping_cart_outlined,
                        size: 25,
                      ),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            height: 12,
                            width: 12,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red, width: 1)),
                            child: BlocConsumer<ProductBloc, ProductState>(
                              listener: (context, state) {
                                if (state is GetCartCountState) {
                                  cartCount = state.count;
                                }
                                if (state is GetProductState) {
                                  productBloc.add(GetCartEvent());
                                }
                              },
                              builder: (context, state) {
                                return Text(
                                  "$cartCount",
                                  style: const TextStyle(color: Colors.black, fontSize: 8),
                                );
                              },
                            ),
                          ))
                    ],
                  )),
            ],
          ),
          body: SmartRefresher(
              controller: _refreshController,
              enablePullUp: true,
              enablePullDown: false,
              onLoading: () {
                productBloc.add(LoadProductEvent(pageNo: pageNo, pageSize: pageSize));
              },
              footer: CustomFooter(
                builder: (context, loadStatus) {
                  if (loadStatus == LoadStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return const SizedBox(
                    width: 0,
                    height: 0,
                  );
                },
              ),
              child: BlocConsumer<ProductBloc, ProductState>(
                listener: (context, state) {
                  if (state is GetProductState) {
                    pageNo = pageNo + 1;
                    _refreshController.loadComplete();
                    _refreshController.refreshCompleted();
                    productList.addAll(state.products);
                  }
                },
                builder: (context, state) {
                  return GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200, childAspectRatio: 0.9, crossAxisSpacing: 10, mainAxisSpacing: 10),
                      itemCount: productList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext ctx, index) {
                        return ProductListItem(
                          product: productList[index],
                          onCartUpdate: () {
                            productBloc.add(GetCartEvent());
                          },
                        );
                      });
                },
              ))),
    );
  }
}

class ProductListItem extends StatefulWidget {
  final ProductModel product;
  final Function onCartUpdate;

  const ProductListItem({Key? key, required this.product, required this.onCartUpdate}) : super(key: key);

  @override
  _ProductListItemState createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  @override
  void didUpdateWidget(covariant ProductListItem oldWidget) {
    debugPrint("_ProductListItemState");
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  image: DecorationImage(image: NetworkImage(widget.product.featuredImage), fit: BoxFit.contain)),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.product.title,
                    maxLines: 2,
                  ),
                ),
                CartWidget(
                  product: widget.product,
                  onCartUpdate: () {
                    widget.onCartUpdate();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CartWidget extends StatefulWidget {
  final ProductModel product;
  final Function onCartUpdate;

  const CartWidget({Key? key, required this.product, required this.onCartUpdate}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  int qty = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    getCartCount(widget.product.id.toString());
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CartWidget oldWidget) {
    debugPrint("_CartWidgetState");
    getCartCount(widget.product.id.toString());
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: IconButton(
                onPressed: () {
                  addToCart();
                },
                splashRadius: 15,
                icon: const Icon(Icons.shopping_cart_outlined)),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              height: 15,
              width: 15,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 1), borderRadius: BorderRadius.circular(10)),
              child: Text(
                qty.toString(),
                style: const TextStyle(fontSize: 10),
              ),
            ),
          )
        ],
      ),
    );
  }

  void getCartCount(String productId) async {
    Cart? cart = await databaseHelper.searchProductFromCart(productId);
    if (cart != null) {
      qty = cart.qty;
      setState(() {});
    }
  }

  void addToCart() async {
    qty = qty + 1;
    Cart cart = Cart(
        price: widget.product.price.toString(),
        totalPrice: (widget.product.price * qty).toString(),
        description: widget.product.description,
        productName: widget.product.title,
        productId: widget.product.id.toString(),
        productImage: widget.product.featuredImage,
        qty: qty);

    await databaseHelper.addProductToCart(cart);
    widget.onCartUpdate();
    getCartCount(widget.product.id.toString());
  }
}
