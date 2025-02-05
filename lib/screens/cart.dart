import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/providers/product_list.dart';
import 'package:e_commerce/Models/Data.dart';

class Cart extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<Cart> {
  List<dynamic> cartItems = [];
  double total = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartItems = Provider.of<CartProvider>(context, listen: false).temp;
  }

  void addCart(int index) {
    setState(() {
      cartItems = Provider.of<CartProvider>(context, listen: false).temp;
    });
    Provider.of<CartProvider>(context, listen: false)
        .incrementQty(cartItems[index]['item_code']);
  }

  void removeCart(int index) {
    setState(() {
      cartItems = Provider.of<CartProvider>(context, listen: false).temp;
    });
    Provider.of<CartProvider>(context, listen: false)
        .decrementQty(cartItems[index]['item_code']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Shopping Cart"),
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItems.length == 0
                ? Center(
                    child: Text("Cart is empty"),
                  )
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(item['item_code'],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("\₹${item['price']}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  removeCart(index);
                                },
                              ),
                              Text(item['qty'].toString(),
                                  style: TextStyle(fontSize: 18)),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  addCart(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    print(cartItems);
                    if (cartItems.length == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Cart is empty"),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    await createSalesOrder(cartItems);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Order placed successfully"),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Provider.of<CartProvider>(context, listen: false)
                        .clearCart();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text("Place order",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
