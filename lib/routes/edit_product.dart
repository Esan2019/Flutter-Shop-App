import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';

import '../size_config.dart';
import '../constants.dart';
import '../models/product.dart';
import '../providers/products.dart';

class EditProduct extends StatefulWidget {
  var _product;

  EditProduct({Product product}) : _product = product ?? Product();

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _titleFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _priceController = MoneyMaskedTextController();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _descriptionFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _priceController.text = widget._product.price.toString();

    _imageUrlFocusNode.addListener(() {
      if (!_imageUrlFocusNode.hasFocus) setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _priceFocusNode.dispose();
    _priceController.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_isFormValid()) {
      _formKey.currentState.save();

      final product = widget._product;
      final productsProvider = Provider.of<Products>(context, listen: false);

      if (productsProvider.contains(product)) {
        productsProvider.editProduct(product);
      } else {
        productsProvider.addProduct(
          product.copyWith(
            id: Random().nextDouble().ceil(),
          ),
        );
      }
    }

    Navigator.of(context).pop();
  }

  bool _isFormValid() {
    return _formKey.currentState.validate();
  }

  void _setProductTitle(String title) {
    widget._product = widget._product.copyWith(title: title);
  }

  void _setProductPrice(String price) {
    widget._product =
        widget._product.copyWith(price: _convertPriceToDouble(price));
  }

  void _setProductDescription(String description) {
    widget._product = widget._product.copyWith(description: description);
  }

  void _setProductImageUrl(String imageUrl) {
    widget._product = widget._product.copyWith(imageUrl: imageUrl);
  }

  String _validateTitle(String title) {
    if (title.isEmpty) {
      return 'Você deve fornecer um título';
    } else {
      return null;
    }
  }

  String _validateImageUrl(String imageUrl) {
    if (imageUrl.isEmpty) {
      return 'Você deve fornecer uma URL';
    } else if (!imageUrl.startsWith('http') || !imageUrl.startsWith('https')) {
      return 'Você deve fornecer uma URL válida';
    } else {
      return null;
    }
  }

  String _validateDescription(String description) {
    if (description.isEmpty) {
      return 'Você deve fornecer uma descrição';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar produto')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            onWillPop: () => _showExitDialog(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: SizeConfig.getHeightPercentage(40),
                  width: SizeConfig.getWidthPercentage(100),
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_imageUrlController.text),
                      onError: (_, stackTrace) {},
                    ),
                  ),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormField(
                        style: productCardPriceStyle,
                        textInputAction: TextInputAction.next,
                        focusNode: _titleFocusNode,
                        validator: _validateTitle,
                        initialValue: widget._product.title,
                        onSaved: (title) => _setProductTitle(title),
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          labelText: 'Título do produto',
                          labelStyle: productCardPriceStyle,
                          border: InputBorder.none,
                        ),
                      ),
                      TextFormField(
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        onSaved: (price) => _setProductPrice(price),
                        focusNode: _priceFocusNode,
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: true,
                        ),
                        textInputAction: TextInputAction.next,
                        style: productCardTitleStyle,
                        decoration: const InputDecoration(
                          labelText: 'Preço',
                          prefixText: 'R\$',
                          prefixStyle: productCardTitleStyle,
                          labelStyle: productCardTitleStyle,
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          validator: _validateImageUrl,
                          initialValue: widget._product.imageUrl,
                          onSaved: (imageUrl) => _setProductImageUrl(imageUrl),
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          focusNode: _imageUrlFocusNode,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'URL da imagem',
                            border: InputBorder.none,
                            labelStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          focusNode: _descriptionFocusNode,
                          validator: _validateDescription,
                          initialValue: widget._product.description,
                          onSaved: (desc) => _setProductDescription(desc),
                          maxLines: 6,
                          scrollPhysics: const BouncingScrollPhysics(),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Descrição do produto',
                            labelStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: RaisedButton(
        child: const Text(
          'SALVAR PRODUTO',
          style: const TextStyle(color: Colors.white),
        ),
        shape: const Border(),
        onPressed: _submitForm,
        color: Theme.of(context).accentColor,
        padding: const EdgeInsets.all(18),
      ),
    );
  }
}

double _convertPriceToDouble(String price) {
  final priceWithDotsRemoved = price.replaceAll('.', '').split(',')[0];
  final priceDecimals = price.split(',')[1];
  final finalPrice =
      double.parse(priceWithDotsRemoved) + double.parse(priceDecimals) / 100;
  return finalPrice;
}

Future<bool> _showExitDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Sair sem salvar?'),
      content: const Text(
        'Tem certeza que deseja descartar as suas alterações?',
      ),
      actions: [
        FlatButton(
          child: const Text('Não, houve um engano'),
          onPressed: () => Navigator.of(ctx).pop(false),
        ),
        FlatButton(
          child: Text(
            'Sim, desejo descartar',
            style: TextStyle(
              color: Theme.of(context).errorColor,
            ),
          ),
          onPressed: () => Navigator.of(ctx).pop(true),
        ),
      ],
    ),
  );
}
