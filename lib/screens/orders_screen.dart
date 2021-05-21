import 'package:flutter/material.dart';
import 'package:p_shop/providers/order.dart';
import 'package:p_shop/widgets/draw_widget.dart';
import 'package:p_shop/widgets/order_widget.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      drawer: DrawApp(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (context, index) => OrderCard(orderData.orders[index]),
      ),
    );
  }
}
