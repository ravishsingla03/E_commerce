import 'dart:math';
import 'package:e_commerce/Models/Data.dart';
import 'package:e_commerce/Models/Products.dart';
import 'package:e_commerce/providers/product_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  int index;
  ProductDetails({required this.index});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addprices();
  }

  void addprices() {
    final temp1 = Provider.of<ProductList>(context, listen: false).products;
    final temp2 = Provider.of<ProductList>(context, listen: false).itemprices;

    for (var item in temp2) {
      final itemcode = item['item_code'];
      String price = item['price_list_rate'].toString();
      for (var product in temp1) {
        if (product.itemCode == itemcode) {
          product.price = price;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(100),
            ),
            child: GestureDetector(
              onTap: () => {
                Navigator.pushNamed(context, '/cart'),
              },
              child: Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Consumer<ProductList>(
          builder: (context, value, model) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(20), // Set border radius
                    image: DecorationImage(
                      image: AssetImage('assets/sample.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  value.products[widget.index].name?.toString() ?? '',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: Text(
                    value.products[widget.index].itemCode?.toString() ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    value.products[widget.index].itemGroup?.toString() ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Text(
                    '₹${value.products[widget.index].price ?? '0'}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Country of Origin: ${value.products[widget.index].countryOfOrigin ?? 'Not available'}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Product Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(value.products[widget.index].description?.toString() ??
                    'No description available'),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final random = Random();
                            final id = random.nextInt(1000);
                            final item = {
                              "item_code":
                                  value.products[widget.index].itemCode,
                              "delivery_date": "2025-12-26",
                              "qty": 1,
                              "price":
                                  value.products[widget.index].price == "null"
                                      ? "0"
                                      : value.products[widget.index].price,
                            };
                            Provider.of<CartProvider>(context, listen: false)
                                .addTerm(item);
                            Navigator.pushNamed(context, '/cart');
                          },
                          icon: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Add to cart",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final random = Random();
                            final id = random.nextInt(1000);
                            final item = {
                              "item_code":
                                  value.products[widget.index].itemCode,
                              "delivery_date": "2025-12-26",
                              "qty": 1,
                              "price":
                                  value.products[widget.index].price == "null"
                                      ? "0"
                                      : value.products[widget.index].price,
                              "id": id,
                            };
                            Provider.of<CartProvider>(context, listen: false)
                                .addTerm(item);
                            Navigator.pushNamed(context, '/cart');
                          },
                          icon: Icon(
                            Icons.touch_app,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Buy Now",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
