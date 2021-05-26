import 'package:flutter/material.dart';
import 'package:p_shop/providers/auth.dart';
import 'package:p_shop/providers/card.dart';
import 'package:p_shop/providers/order.dart';
import 'package:p_shop/providers/products.dart';
import 'package:p_shop/screens/auth_screen.dart';
import 'package:p_shop/screens/cart_screen.dart';
import 'package:p_shop/screens/edit_product_screen.dart';
import 'package:p_shop/screens/orders_screen.dart';
import 'package:p_shop/screens/product_detail_screen.dart';
import 'package:p_shop/screens/product_overtview_screen.dart';
import 'package:p_shop/screens/splash_screen.dart';

import 'package:p_shop/screens/user_product_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => null,
          update: (ctx, auth, previousProduct) => Products(
              auth.token,
              auth.userId,
              previousProduct == null ? [] : previousProduct.items),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (_) => null,
          update: (ctx, auth, previousOrder) => Order(auth.token, auth.userId,
              previousOrder == null ? [] : previousOrder.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, resultSnapshot) =>
                      resultSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetail.routeName: (ctx) => ProductDetail(),
            CartPage.routeName: (ctx) => CartPage(),
            OrderScreen.routeName: (context) => OrderScreen(),
            UserProductScreen.routeName: (context) => UserProductScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
