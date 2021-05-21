import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p_shop/providers/product.dart';
import 'package:p_shop/providers/products.dart';
import 'package:p_shop/screens/user_product_screen.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocus = FocusNode();
  final _descFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocus = FocusNode();

  final _form = GlobalKey<FormState>();
  bool _isloading = false;
  var _editProduct =
      Product(id: null, title: '', desc: '', price: 0, imageUrl: '');
  //tao doi tuong de ghi de
  var _initValue = {
    'title': '',
    'desc': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocus.addListener(_updateImageUrl);
    super.initState();
  }

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        //search product by ID
        _editProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValue = {
          'title': _editProduct.title,
          'desc': _editProduct.desc,
          'price': _editProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocus.removeListener(_updateImageUrl);
    _priceFocus.dispose();
    _descFocus.dispose();
    _imageUrlController.dispose();
    _imageUrlFocus.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocus.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          !_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https') ||
          !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpeg')) {
        return;
      }
      setState(() {});
    }
  }

  //save new product
  void _saveForm() {
    final _isValidate = _form.currentState.validate();
    if (!_isValidate) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isloading = true;
    });
    if (_editProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
      setState(() {
        _isloading = false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editProduct)
          .catchError(
        (error) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An error occurrend !'),
              content: Text('Something went wrong.'),
              actions: [
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(ctx)
                        .pushReplacementNamed(UserProductScreen.routeName);
                  },
                ),
              ],
            ),
          );
        },
      ).then(
        (_) {
          setState(() {
            _isloading = false;
          });
          Navigator.of(context).pop();
        },
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValue['title'],
                      decoration: InputDecoration(labelText: 'title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          title: value,
                          price: _editProduct.price,
                          desc: _editProduct.desc,
                          imageUrl: _editProduct.imageUrl,
                          id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Value not empty';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['price'],
                      decoration: InputDecoration(labelText: 'price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descFocus);
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          title: _editProduct.title,
                          price: double.parse(value),
                          desc: _editProduct.desc,
                          imageUrl: _editProduct.imageUrl,
                          id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                      focusNode: _priceFocus,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter valid number';
                        }
                        if (double.parse(value) < 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['desc'],
                      decoration: InputDecoration(labelText: 'Discription'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descFocus,
                      onSaved: (value) {
                        _editProduct = Product(
                          title: _editProduct.title,
                          price: _editProduct.price,
                          desc: value,
                          imageUrl: _editProduct.imageUrl,
                          id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Value not empty';
                        }
                        if (value.length > 50) {
                          return 'Description cant not longer than 50';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(right: 10, top: 15),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Center(child: Text('Enter your URL'))
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocus,
                            onSaved: (value) {
                              _editProduct = Product(
                                title: _editProduct.title,
                                price: _editProduct.price,
                                desc: _editProduct.desc,
                                imageUrl: value,
                                id: _editProduct.id,
                                isFavorite: _editProduct.isFavorite,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              if (!value.endsWith('.jpg') &&
                                  !value.endsWith('.png') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image URL.';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => _saveForm(),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
