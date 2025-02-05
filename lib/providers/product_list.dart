import 'package:flutter/material.dart';
import 'package:e_commerce/Models/products.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce/Models/cache.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductList extends ChangeNotifier {
  List<Product> _products = [];
  List<dynamic> _itemprices = [];

  List<dynamic> get itemprices {
    return [..._itemprices];
  }

  List<Product> get products {
    return [..._products];
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse(
        'https://core-dev.excitor.tech/api/resource/Item?fields=["*"]');

    final response = await http.get(
      url,
      headers: {
        'Authorization':'${dotenv.env['API_KEY']}',
        'Cookie':
            'full_name=Guest; sid=Guest; system_user=no; user_id=Guest; user_image=',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final products = data['data'] as List<dynamic>;
      final List<Product> loadedProducts = [];
      for (final product in products) {
        loadedProducts.add(
          Product(
            name: product['item_name'],
            itemCode: product['item_code'],
            itemGroup: product['item_group'],
            description: product['description'],
            isStockItem: product['is_stock_item'],
            countryOfOrigin: product['country_of_origin'],
            image: product['image'],
          ),
        );
      }
      _products = loadedProducts;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> fetchItemPrices() async {
    final url = Uri.parse(
        'https://core-dev.excitor.tech/api/resource/Item Price?fields=["*"]');

    final response = await http.get(
      url,
      headers: {
        'Authorization':'${dotenv.env['API_KEY']}',
        'Cookie':
            'full_name=Guest; sid=Guest; system_user=no; user_id=Guest; user_image=',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final data2 = data['data'] as List<dynamic>;
      _itemprices = data2;
    } else {
      throw Exception('Failed to load item prices');
    }
  }
}

class CartProvider extends ChangeNotifier {
  List<dynamic> _temp = [
    {
      "item_code": "Frappe",
      "delivery_date": "2025-12-26",
      "qty": 1,
      "price": "100.00",
    }
  ];

  List<dynamic> get temp => _temp;
  Future<void> addTerm(Map<String, dynamic> term) async {
    //check if the list contains the term by item_code then increment the qty
    //if not add the term to the list

    final index = _temp
        .indexWhere((element) => element['item_code'] == term['item_code']);
    if (index != -1) {
      _temp[index]['qty'] += 1;
    } else {
      _temp.add(term);
    }

    // await CacheUtil.addItemToList('cart', term);
    await CacheUtil.setList("cart", _temp as List<Map<String, dynamic>>);
    notifyListeners();
  }

  Future<void> incrementQty(String item_code) async {
    final index =
        _temp.indexWhere((element) => element['item_code'] == item_code);
    if (index != -1) {
      _temp[index]['qty'] += 1;
    }
    await CacheUtil.setList("cart", _temp as List<Map<String, dynamic>>);
    notifyListeners();
  }

  
  //decrement the qty
  Future<void> decrementQty(String item_code) async {
    final index =
        _temp.indexWhere((element) => element['item_code'] == item_code);
    if (index != -1) {
      _temp[index]['qty'] -= 1;
      if (_temp[index]['qty'] == 0) {
        _temp.removeAt(index);
      }
    }
    await CacheUtil.setList("cart", _temp as List<Map<String, dynamic>>);
    notifyListeners();
  }

  Future<void> removeTerm(Map<String, dynamic> term) async {
    _temp.remove(term);
    await CacheUtil.removeItemFromList('cart', term);
    notifyListeners();
  }

  void clearCart() {
    _temp = [];
    CacheUtil.clear();
    notifyListeners();
  }

  Future<void> fetchCart() async {
    _temp = await CacheUtil.getList('cart');
    notifyListeners();
  }
}
