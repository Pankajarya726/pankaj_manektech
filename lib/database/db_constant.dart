class DBConstant {
  static const dbName = "product.db";
  static const cartTable = "cart_table";

  static const id = "id";
  static const productName = "product_name";
  static const description = "description";
  static const productId = "product_id";
  static const productImage = "product_image";
  static const price = "price";
  static const qty = "qty";
  static const totalPrice = "total_price";

  //crate table query
  static const String createCartTable = "CREATE TABLE " +
      cartTable +
      "(" +
      id +
      " INTEGER PRIMARY KEY AUTOINCREMENT , " +
      productId +
      " TEXT," +
      productName +
      " TEXT," +
      productImage +
      " TEXT," +
      qty +
      " INTEGER," +
      price +
      " TEXT," +
      totalPrice +
      " TEXT," +
      description +
      " TEXT )";
}

class Cart {
  String productName = "";
  String productId = "";
  String productImage = "";
  String description = "";
  String totalPrice = "";
  String price = "";
  int qty = 0;

  Cart(
      {required this.productName,
      required this.productId,
      required this.productImage,
      required this.description,
      required this.price,
      required this.totalPrice,
      required this.qty});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "product_name": productName,
      "product_id": productId,
      "product_image": productImage,
      "total_price": totalPrice,
      "price": price,
      "qty": qty,
      "description": description,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> json) => Cart(
        productName: json["product_name"],
        productImage: json['product_image'],
        productId: json["product_id"],
        description: json["description"],
        totalPrice: json["total_price"],
        price: json["price"],
        qty: json["qty"],
      );
}
