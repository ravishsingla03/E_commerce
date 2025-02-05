import 'package:e_commerce/providers/product_list.dart';
import 'package:e_commerce/screens/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/Product_Details.dart';
import './screens/Cart.dart';
import 'Models/cache.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await CacheUtil.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductList()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        darkTheme: ThemeData.dark(),
        home: Homepage(),
        routes: {
          '/home': (context) => Homepage(),
          '/cart': (context) => Cart(),
        },
      ),
    );
  }
}
