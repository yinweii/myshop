import 'package:flutter/material.dart';
import 'package:p_shop/providers/card.dart';
import 'package:p_shop/providers/order.dart';
import 'package:p_shop/providers/products.dart';
import 'package:p_shop/screens/cart_screen.dart';
import 'package:p_shop/screens/edit_product_screen.dart';
import 'package:p_shop/screens/orders_screen.dart';
import 'package:p_shop/screens/product_detail_screen.dart';
import 'package:p_shop/screens/product_overtview_screen.dart';
import 'package:p_shop/screens/user_product_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Order(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetail.routeName: (ctx) => ProductDetail(),
          CartPage.routeName: (ctx) => CartPage(),
          OrderScreen.routeName: (context) => OrderScreen(),
          UserProductScreen.routeName: (context) => UserProductScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen(),
        },
      ),
    );
  }
}
