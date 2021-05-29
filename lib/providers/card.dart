import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final String imageUrl;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.imageUrl,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

//---------------
  int get itemCount {
    return _items.length;
  }

  //total
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

//add cart
  void addItem(String productId, String title, String imageUrl, double price) {
    if (_items.containsKey(productId)) {
      //thay doi so luong
      _items.update(
        productId,
        (exittingCartItem) => CartItem(
            id: exittingCartItem.id,
            title: exittingCartItem.title,
            imageUrl: exittingCartItem.imageUrl,
            quantity: exittingCartItem.quantity + 1,
            price: exittingCartItem.price),
      );
    } else {
      _items.putIfAbsent(
        //tim kiem hoac them gia tri neu khong co
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            imageUrl: imageUrl,
            quantity: 1,
            price: price),
      );
    }
    notifyListeners();
  }

  //delete cartItem
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  //remove signle Item
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      // neu quantity > 1 thi giam
      _items.update(
        //cap nhap gio hang hien co
        productId,
        (exitingCartItem) => CartItem(
            id: exitingCartItem.id,
            title: exitingCartItem.title,
            imageUrl: exitingCartItem.imageUrl,
            quantity: exitingCartItem.quantity - 1,
            price: exitingCartItem.price),
      );
    } else {
      // quantity = 1 thi xoa het
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
