import 'dart:developer';

import 'package:com_pankaj_test/database/db_constant.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper db = DatabaseHelper.internal();

  DatabaseHelper.internal();

  factory DatabaseHelper() {
    return db;
  }

  static Database? database;

  static Future<Database> getDatabase() async {
    database ??= await initDB();
    return database!;
  }

  //init data base
  static initDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, DBConstant.dbName);
    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute(DBConstant.createCartTable);
    });
  }

  //Clear database
  clearDatabase() async {
    debugPrint("clearDatabase---->");

    try {
      final db = await getDatabase();
      //here we execute a query to drop the table if exists which is called "tableName"
      //and could be given as method's input parameter too
      await db.execute("DROP TABLE IF EXISTS " + DBConstant.cartTable);
      await db.execute(DBConstant.createCartTable);
    } catch (error) {
      debugPrint("error---->$error");
      // throw Exception('DatabaseHelper.clearDatabase: ' + error.toString());
    }
  }

  Future<int> clearCart() async {
    debugPrint("clearCart---->");
    int i = 0;
    try {
      final db = await getDatabase();

      int i = await db.delete(DBConstant.cartTable);
      return i;
    } catch (error) {
      debugPrint("error---->$error");
      return i;
    }
  }

  Future<int> addProductToCart(Cart cart) async {
    debugPrint('addProductToCart--->$cart');
    int i = 0;
    try {
      final db = await getDatabase();

      Cart? mCart = await searchProductFromCart(cart.productId);
      if (mCart == null) {
        i = await db.insert(DBConstant.cartTable, cart.toMap());
      } else {
        i = await updateCart(cart);
      }

      return i;
    } catch (error) {
      debugPrint("error---->$error");
      return i;
    }
  }

  Future<List<Cart>> getCart() async {
    debugPrint('getCart--->');
    List<Cart> cart = [];

    try {
      final db = await getDatabase();
      String query = "SELECT * FROM ${DBConstant.cartTable} ";
      List<Map<String, dynamic>> result = await db.query(
        DBConstant.cartTable,
      );

      Future.forEach(result, (Map<String, dynamic> data) {
        debugPrint("cart-item--->$data");
        cart.add(Cart.fromMap(data));
      });

      return cart;
    } catch (error) {
      debugPrint("error---->$error");
      return cart;
    }
  }

  Future<Cart?> searchProductFromCart(String productId) async {
    debugPrint('searchProductFromCart--->$productId');
    Cart? cart;

    try {
      final db = await getDatabase();

      List<Map<String, dynamic>> result =
          await db.query(DBConstant.cartTable, where: DBConstant.productId + " = ?", whereArgs: [productId]);
      log('result--->$result');
      if (result.isNotEmpty) {
        return cart = Cart.fromMap(result.first);
      }

      return cart;
    } catch (error) {
      debugPrint("error---->$error");
      return cart;
    }
  }

  Future<int> updateCart(Cart cart) async {
    debugPrint('updateCart--->$cart');
    int i = 0;
    try {
      final db = await getDatabase();
      int i = await db.update(DBConstant.cartTable, cart.toMap(), where: DBConstant.productId + " = ?", whereArgs: [cart.productId]);
      return i;
    } catch (error) {
      debugPrint("error---->$error");
      return i;
    }
  }

  Future<Map<String, dynamic>> getTotalItemCount() async {
    Map<String, dynamic> total = {};
    try {
      final db = await getDatabase();
      String query =
          "SELECT SUM(${DBConstant.qty}) AS total_qty, SUM(${DBConstant.totalPrice}) AS grand_total FROM ${DBConstant.cartTable}";
      List<Map<String, dynamic>> sum = await db.rawQuery(query);

      if (sum.isNotEmpty) {
        total = sum.first;
      }

      return total;
    } catch (error) {
      return total;
    }
  }

  Future<int> deleteProductFromCart(String productId) async {
    debugPrint('deleteProductFromCart--->$productId');
    int i = 0;
    try {
      final db = await getDatabase();
      int i = await db.delete(DBConstant.cartTable, where: DBConstant.productId + " = ?", whereArgs: [productId]);
      return i;
    } catch (error) {
      debugPrint("error---->$error");
      return i;
    }
  }
}
