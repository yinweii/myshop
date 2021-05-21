import 'package:flutter/material.dart';
import 'package:p_shop/providers/card.dart';
import 'package:p_shop/providers/order.dart';
import 'package:p_shop/widgets/cart_item_widget.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                Chip(
                  label: Text(
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                FlatButton(
                    onPressed: () {
                      Provider.of<Order>(context, listen: false).addOrder(
                          cart.items.values.toList(), cart.totalAmount);
                      cart.clear();
                    },
                    child: Text('Oder now')),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) => CartItemBad(
                cart.items.values.toList()[index].id,
                cart.items.values.toList()[index].title,
                cart.items.values.toList()[index].price,
                cart.items.values.toList()[index].quantity,
                cart.items.keys.toList()[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
