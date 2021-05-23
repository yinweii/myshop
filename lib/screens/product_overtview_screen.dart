import 'package:flutter/material.dart';
import 'package:p_shop/providers/card.dart';
import 'package:p_shop/providers/products.dart';
import 'package:p_shop/screens/cart_screen.dart';
import 'package:p_shop/widgets/badge_widget.dart';
import 'package:p_shop/widgets/draw_widget.dart';
import 'package:p_shop/widgets/products_gridview_widget.dart';
import 'package:provider/provider.dart';

enum filterOptions { Favorite, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var showOnlyFavs = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetData().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (filterOptions selectValue) {
              print(selectValue);
              setState(() {
                if (selectValue == filterOptions.Favorite) {
                  // do Favorite
                  showOnlyFavs = true;
                } else {
                  //..
                  showOnlyFavs = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only favorite'),
                value: filterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: filterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: DrawApp(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(
              showFavorites: showOnlyFavs,
            ),
    );
  }
}
