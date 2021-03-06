import 'package:flutter/material.dart';
import 'package:p_shop/providers/auth.dart';
import 'package:p_shop/screens/orders_screen.dart';
import 'package:p_shop/screens/user_product_screen.dart';
import 'package:provider/provider.dart';

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
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
