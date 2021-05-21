import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:p_shop/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: '1',
        title: 'Meo',
        desc: 'Meomeo',
        imageUrl:
            'https://photographer.com.vn/wp-content/uploads/2020/09/1600100131_649_Tong-hop-hinh-anh-gai-xinh-trieu-like-tren-FaceBook.jpg',
        price: 1.22),
    Product(
        id: '2',
        title: 'Meo 2',
        desc: 'Meomeo 2',
        imageUrl:
            'https://icapi.org/wp-content/uploads/2019/10/anh-gai-xinh-deo-kinh-2.jpg',
        price: 5.22),
    Product(
        id: '3',
        title: 'Meo 3',
        desc: 'Meomeo 4',
        imageUrl:
            'https://photographer.com.vn/wp-content/uploads/2020/09/1600100095_144_Tong-hop-hinh-anh-gai-xinh-trieu-like-tren-FaceBook.jpg',
        price: 7.22),
    Product(
      id: 'p41',
      title: 'A Girl',
      desc: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://icapi.org/wp-content/uploads/2019/10/anh-gai-xinh-deo-kinh-43.jpg',
    ),
    Product(
      id: 'p42',
      title: 'A Girl 2',
      desc: 'Prepare any meal you want.',
      price: 33.99,
      imageUrl:
          'https://icapi.org/wp-content/uploads/2019/10/anh-gai-xinh-deo-kinh-10.jpg',
    ),
    Product(
      id: 'p43',
      title: 'A Girl 3',
      desc: 'Prepare any meal you want.',
      price: 11.99,
      imageUrl:
          'https://icapi.org/wp-content/uploads/2019/10/anh-gai-xinh-deo-kinh-12.jpg',
    ),
  ];
  var _showFavoriteOnly = false;
  //find favorite product
  List<Product> get items {
    if (_showFavoriteOnly) {
      return _items.where((prodItem) => prodItem.isFavorite).toList();
    } else {
      return [..._items];
    }
  }

//
  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  //update product
  void updateProduct(String id, Product newProduct) {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    //
    if (productIndex >= 0) {
      _items[productIndex] = newProduct;
      notifyListeners();
    }
    print('...');
  }

//show Favorute Product
  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

//add new product
  Future<void> addProduct(Product product) {
    //_item.add(values)
    const url =
        'https://myshop-b6092-default-rtdb.firebaseio.com/products.json';
    return http
        .post(Uri.parse(url),
            body: jsonEncode({
              'title': product.title,
              'desc': product.desc,
              'price': product.price,
              'imageUrl': product.imageUrl,
              'isfavorite': product.isFavorite,
            }))
        .then((response) {
      final newProduct = Product(
        id: jsonDecode(response.body)['name'],
        title: product.title,
        desc: product.desc,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); //chen vao vi tri dau tien
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  //delete product
  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
