import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:p_shop/models/http_exception.dart';
import 'package:p_shop/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //     id: '1',
    //     title: 'Meo',
    //     desc: 'Meomeo',
    //     imageUrl:
    //         'https://photographer.com.vn/wp-content/uploads/2020/09/1600100131_649_Tong-hop-hinh-anh-gai-xinh-trieu-like-tren-FaceBook.jpg',
    //     price: 1.22),
    // Product(
    //     id: '2',
    //     title: 'Meo 2',
    //     desc: 'Meomeo 2',
    //     imageUrl:
    //         'https://icapi.org/wp-content/uploads/2019/10/anh-gai-xinh-deo-kinh-2.jpg',
    //     price: 5.22),
    // Product(
    //     id: '3',
    //     title: 'Meo 3',
    //     desc: 'Meomeo 4',
    //     imageUrl:
    //         'https://photographer.com.vn/wp-content/uploads/2020/09/1600100095_144_Tong-hop-hinh-anh-gai-xinh-trieu-like-tren-FaceBook.jpg',
    //     price: 7.22),
    // Product(
    //   id: 'p41',
    //   title: 'A Girl',
    //   desc: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://icapi.org/wp-content/uploads/2019/10/anh-gai-xinh-deo-kinh-43.jpg',
    // ),
    // Product(
    //   id: 'p42',
    //   title: 'A Girl 2',
    //   desc: 'Prepare any meal you want.',
    //   price: 33.99,
    //   imageUrl:
    //       'https://icapi.org/wp-content/uploads/2019/10/anh-gai-xinh-deo-kinh-10.jpg',
    // ),
    // Product(
    //   id: 'p43',
    //   title: 'A Girl 3',
    //   desc: 'Prepare any meal you want.',
    //   price: 11.99,
    //   imageUrl:
    //       'https://icapi.org/wp-content/uploads/2019/10/anh-gai-xinh-deo-kinh-12.jpg',
    // ),
  ];
  // authtoken
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);
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

//show Favorute Product
  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

//fetch data
  Future<void> fetchAndSetData([bool filterByuser = false]) async {
    final filterString =
        filterByuser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://myshop-b6092-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    final favoriteUrl =
        'https://myshop-b6092-default-rtdb.firebaseio.com/userFavorite/$userId.json?auth=$authToken';
    final favoriteResponse = await http.get(Uri.parse(favoriteUrl));
    final favoriteData = json.decode(favoriteResponse.body);

    try {
      final response = await http.get(
        Uri.parse(url),
      );

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadData = [];
      extractedData.forEach((prodId, prodData) {
        loadData.add(
          Product(
            id: prodId,
            title: prodData['title'],
            desc: prodData['desc'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ),
        );
      });
      _items = loadData;
      notifyListeners();
      //print(json.decode(response.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

//add new product
  Future<void> addProduct(Product product) async {
    //_item.add(values)
    final url =
        'https://myshop-b6092-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      var response = await http.post(Uri.parse(url),
          body: jsonEncode({
            'title': product.title,
            'desc': product.desc,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
            'isfavorite': product.isFavorite,
          }));

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
    } catch (e) {
      print(e);
      throw e;
    }
  }

  //update product
  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    //
    if (productIndex >= 0) {
      final url =
          'https://myshop-b6092-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'desc': newProduct.desc,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    }
    print('...');
  }

  //delete product
  Future<void> deleteProduct(String id) async {
    final url =
        'https://myshop-b6092-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Can not delete product!');
    }
    existingProduct = null;

    //_items.removeWhere((prod) => prod.id == id);
  }
}
