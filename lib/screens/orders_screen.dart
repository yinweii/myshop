import 'package:flutter/material.dart';
import 'package:p_shop/providers/order.dart';
import 'package:p_shop/widgets/draw_widget.dart';
import 'package:p_shop/widgets/order_widget.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future _orderFuture;
  //
  Future _obtainOrderFuture() {
    return Provider.of<Order>(context, listen: false).fetchAndSetOrder();
  }

  @override
  void initState() {
    _orderFuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building order screen');
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      drawer: DrawApp(),
      body: FutureBuilder(
        future: _orderFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              /**
               * do something error
               */
              return Center(
                child: Text('An error wrong!'),
              );
            } else {
              return Consumer<Order>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (context, index) => OrderCard(
                    orderData.orders[index],
                    orderData.orders[index].id,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
