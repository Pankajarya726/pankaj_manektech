// To parse this JSON data, do
//
//     final productResponse = productResponseFromMap(jsonString);

import 'dart:convert';

class ProductResponse {
  ProductResponse({
    required this.status,
    required this.message,
    required this.totalRecord,
    required this.totalPage,
    required this.data,
  });

  int status;
  String message;
  int totalRecord;
  int totalPage;
  List<ProductModel> data;

  factory ProductResponse.fromJson(String str) => ProductResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductResponse.fromMap(Map<String, dynamic> json) => ProductResponse(
        status: json["status"],
        message: json["message"],
        totalRecord: json["totalRecord"],
        totalPage: json["totalPage"],
        data: json["data"] == null ? [] : List<ProductModel>.from(json["data"].map((x) => ProductModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "totalRecord": totalRecord,
        "totalPage": totalPage,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class ProductModel {
  ProductModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.price,
    required this.featuredImage,
    required this.status,
    required this.createdAt,
  });

  int id;
  String slug;
  String title;
  String description;
  int price;
  int qty = 0;
  String featuredImage;
  String status;
  DateTime createdAt;

  factory ProductModel.fromJson(String str) => ProductModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
        id: json["id"] ?? 0,
        slug: json["slug"] ?? "",
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        price: json["price"] ?? 0,
        featuredImage: json["featured_image"] ?? "",
        status: json["status"] ?? "",
        createdAt: json["created_at"] == null ? DateTime.now() : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "slug": slug,
        "title": title,
        "description": description,
        "price": price,
        "featured_image": featuredImage,
        "status": status,
        "created_at": createdAt.toIso8601String(),
      };
}
