import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:p_shop/models/http_exception.dart';
import 'package:p_shop/providers/card.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;
  Order(this.authToken, this.userId, this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrder() async {
    final url =
        'https://myshop-b6092-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    final response = await http.get(Uri.parse(url));
    // print(json.decode(response.body));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  imageUrl: item['imageUrl'],
                  quantity: item['quantity'],
                  price: item['price'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url =
        'https://myshop-b6092-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': DateTime.now().toIso8601String(),
          'products': cartProduct
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['namee'],
          amount: total,
          dateTime: DateTime.now(),
          products: cartProduct),
    );
    notifyListeners();
  }

  Future<void> deleteOrder(String id) async {
    final url =
        'https://myshop-b6092-default-rtdb.firebaseio.com/orders/$userId/$id.json?auth=$authToken';
    final existingOrderIndex = _orders.indexWhere((ordeId) => ordeId.id == id);
    var existingOrder = _orders[existingOrderIndex];
    _orders.removeAt(existingOrderIndex);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _orders.insert(existingOrderIndex, existingOrder);
      notifyListeners();
      throw HttpException('Can not delete this order!');
    }
    existingOrder = null;
  }
}
