import 'package:flutter/material.dart';
import 'package:p_shop/screens/orders_screen.dart';
import 'package:p_shop/screens/user_product_screen.dart';

class DrawApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hi! Phong'),
            automaticallyImplyLeading: false,
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Order'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
