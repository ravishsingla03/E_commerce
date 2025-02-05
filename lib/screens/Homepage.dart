import 'package:e_commerce/providers/product_list.dart';
import 'package:e_commerce/screens/Product_Details.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/Models/Products.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isLoading = true;
  List<Product> finaldata = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await Provider.of<ProductList>(context, listen: false).fetchProducts();
      await Provider.of<ProductList>(context, listen: false).fetchItemPrices();
      await Provider.of<CartProvider>(context, listen: false).fetchCart();
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching products: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final finaldata = Provider.of<ProductList>(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Products List')),
      ),
      body: SafeArea(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 5,
                  ),
                  itemCount: finaldata.products.length,
                  itemBuilder: (context, index) {
                    return Consumer<ProductList>(
                      builder: (context, value, model) => GestureDetector(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetails(index: index))),
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            children: [
                              Image(
                                image: AssetImage(
                                  'assets/sample.jpg',
                                ),
                                fit: BoxFit.contain,
                              ),
                              ListTile(
                                title: Text(finaldata.products[index].name!,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                  finaldata.products[index].itemGroup
                                      .toString(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
    );
  }
}
