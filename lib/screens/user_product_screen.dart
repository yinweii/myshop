import 'package:flutter/material.dart';
import 'package:p_shop/providers/products.dart';
import 'package:p_shop/screens/edit_product_screen.dart';
import 'package:p_shop/widgets/draw_widget.dart';
import 'package:p_shop/widgets/user_product_widget.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: DrawApp(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: productData.items.length,
          itemBuilder: (_, index) => Column(
            children: [
              UserProductItem(
                  productData.items[index].id,
                  productData.items[index].title,
                  productData.items[index].imageUrl),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
