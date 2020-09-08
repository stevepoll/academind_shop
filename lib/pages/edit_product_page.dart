import 'package:academind_shop/providers/product.dart';
import 'package:academind_shop/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductPage extends StatefulWidget {
  static const routeName = '/edit_products';

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final _form = GlobalKey<FormState>();
  var _editing = false;

  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
    isFavorite: false,
  );

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageURL);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageURL);
    Future.delayed(Duration.zero, () {
      final id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        setState(() {
          _editedProduct =
              Provider.of<Products>(context, listen: false).findById(id);
          _titleController.text = _editedProduct.title;
          _priceController.text = _editedProduct.price.toString();
          _descController.text = _editedProduct.description;
          _imageUrlController.text = _editedProduct.imageUrl;
          _editing = true;
        });
      }
    });
    super.initState();
  }

  void _updateImageURL() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    final products = Provider.of<Products>(context, listen: false);
    if (_editing) {
      products.updateProduct(_editedProduct);
    } else {
      products.addProduct(_editedProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_editing ? 'Edit Product' : 'Add Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) =>
                    focus.requestFocus(_priceFocusNode),
                onSaved: (value) {
                  _editedProduct = _editedProduct.copyWith(title: value);
                },
                controller: _titleController,
                validator: (value) {
                  return value.isEmpty ? 'Please provide a title' : null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (value) => focus.requestFocus(_descFocusNode),
                onSaved: (value) => _editedProduct =
                    _editedProduct.copyWith(price: double.parse(value)),
                controller: _priceController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0.0) {
                    return 'Please enter a positive number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descFocusNode,
                onSaved: (value) => _editedProduct =
                    _editedProduct.copyWith(description: value),
                controller: _descController,
                validator: (value) {
                  if (value.isEmpty || value.length <= 10) {
                    return 'Please enter a description of at least 10 characters';
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
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Center(child: Text('Enter a URL'))
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageFocusNode,
                      onFieldSubmitted: (value) {
                        _saveForm();
                      },
                      onSaved: (value) => _editedProduct =
                          _editedProduct.copyWith(imageUrl: value),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an image URL';
                        }
                        if (!value.startsWith('http')) {
                          return 'Please enter a valid URL';
                        }
                        if (!(value.endsWith('.png') ||
                            value.endsWith('.jpg') ||
                            value.endsWith('.jpeg'))) {
                          return 'URL must end with png, jpg, or jpeg';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
