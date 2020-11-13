import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../size_config.dart';
import '../constants.dart';
import '../models/product.dart';
import '../providers/products.dart';
import '../widgets/fallback_product_image.dart';

class EditProduct extends StatefulWidget {
  final _product;
  final ScaffoldState ancestorScaffold;

  EditProduct({
    Product product,
    this.ancestorScaffold,
  }) : _product = product ?? Product();

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
  Product _product;
  Products _productsProvider;
  bool _isPerformingDatabaseOperation = false;
  bool _isEditingAnExistingProduct;
  final _previewImageKey = GlobalKey<_PreviewImageState>();
  _PreviewImage _previewImage;

  @override
  void initState() {
    _productsProvider = Provider.of<Products>(context, listen: false);
    _product = widget._product;
    _isEditingAnExistingProduct = _productsProvider.contains(_product);
    _priceController.text = _product.price.toStringAsFixed(2);
    _imageUrlController.text = _product.imageUrl ?? '';
    
    _previewImage = _PreviewImage(
      initialUrl: _imageUrlController.text,
      key: _previewImageKey,
    );

    _imageUrlFocusNode.addListener(() {
      if (!_imageUrlFocusNode.hasFocus) _updatePreviewImage();
    });

    super.initState();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _priceFocusNode.dispose();
    _priceController.dispose();
    _imageUrlFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final form = _formKey.currentState;
    final isFormValid = form.validate();

    if (!isFormValid) return;

    form.save();

    if (_isEditingAnExistingProduct) {
      _productsProvider.editProduct(_product).catchError((error) {
        _showSnackBarInAncestorScaffold(error);
      });
    }

    if (!_isEditingAnExistingProduct) {
      setState(() => _isPerformingDatabaseOperation = true);

      await _productsProvider.addProduct(_product).catchError((error) {
        _showSnackBarInAncestorScaffold(error);
      });
    }

    Navigator.of(context).pop();
  }

  void _showSnackBarInAncestorScaffold(String content) {
    widget.ancestorScaffold.showSnackBar(SnackBar(content: Text(content)));
  }

  void _setProductTitle(String title) {
    _product = _product.copyWith(title: title);
  }

  void _setProductPrice(String price) {
    _product = _product.copyWith(price: _convertPriceToDouble(price));
  }

  void _setProductDescription(String description) {
    _product = _product.copyWith(description: description);
  }

  void _setProductImageUrl(String imageUrl) {
    _product = _product.copyWith(imageUrl: imageUrl);
  }

  void _updatePreviewImage() {
    _previewImageKey.currentState.updatePreview(_imageUrlController.text);
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

  TextFormField _generateFormField({
    @required String labelText,
    String prefixText,
    TextEditingController controller,
    String initialValue,
    FocusNode focusNode,
    int maxLines = 1,
    TextInputType keyboardType,
    TextInputAction textInputAction,
    String Function(String) validator,
    void Function(String) onSaved,
    void Function(String) onFieldSubmitted,
  }) {
    return TextFormField(
      cursorColor: Theme.of(context).accentColor,
      maxLines: maxLines,
      initialValue: initialValue,
      decoration: InputDecoration(
        border: InputBorder.none,
        fillColor: Theme.of(context).primaryColor,
        filled: true,
        labelText: labelText,
        prefixText: prefixText,
        labelStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      onSaved: onSaved,
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction ?? TextInputAction.next,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isPerformingDatabaseOperation
          ? Center(child: Lottie.asset('assets/animations/bouncy-balls.json'))
          : SafeArea(
              child: Form(
                key: _formKey,
                onWillPop: () => _showExitDialog(context),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: SizeConfig.getHeightPercentage(30),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(fallbackImagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: _previewImage,
                        ),
                        SizedBox(height: 8),
                        _generateFormField(
                          labelText: 'Título do produto',
                          initialValue: _product.title,
                          validator: _validateTitle,
                          focusNode: _titleFocusNode,
                          onSaved: _setProductTitle,
                          onFieldSubmitted: (_) =>
                              _priceFocusNode.requestFocus(),
                        ),
                        SizedBox(height: 8),
                        _generateFormField(
                          labelText: 'Preço do produto',
                          prefixText: 'R\$',
                          controller: _priceController,
                          focusNode: _priceFocusNode,
                          onSaved: _setProductPrice,
                          onFieldSubmitted: (_) =>
                              _imageUrlFocusNode.requestFocus(),
                          keyboardType: TextInputType.numberWithOptions(
                            signed: true,
                          ),
                        ),
                        SizedBox(height: 8),
                        _generateFormField(
                          labelText: 'URL da imagem',
                          validator: _validateImageUrl,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          onSaved: _setProductImageUrl,
                          onFieldSubmitted: (_) =>
                              _descriptionFocusNode.requestFocus(),
                        ),
                        SizedBox(height: 8),
                        _generateFormField(
                          labelText: 'Descrição do produto',
                          initialValue: _product.description,
                          maxLines: 10,
                          validator: _validateDescription,
                          focusNode: _descriptionFocusNode,
                          textInputAction: TextInputAction.newline,
                          onSaved: _setProductDescription,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RaisedButton(
              child: Text('Descartar'),
              textColor: Colors.white,
              onPressed: () => Navigator.of(context).maybePop(),
              color: Colors.red,
            ),
            RaisedButton(
              child: Text('Salvar produto'),
              textColor: Colors.white,
              onPressed: _submitForm,
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewImage extends StatefulWidget {
  final String initialUrl;
  const _PreviewImage({this.initialUrl, Key key}) : super(key: key);

  @override
  _PreviewImageState createState() => _PreviewImageState();
}

class _PreviewImageState extends State<_PreviewImage> {
  String imageUrl;
  bool canLoadImage = true;

  @override
  void initState() {
    imageUrl = widget.initialUrl;
    super.initState();
  }

  void updatePreview(String newUrl) => setState(() {
        imageUrl = newUrl;
        canLoadImage = true;
      });

  @override
  Widget build(BuildContext context) {
    return canLoadImage
        ? Image(
            image: NetworkImage(imageUrl),
            width: SizeConfig.screenWidth,
            height: SizeConfig.getHeightPercentage(30),
            fit: BoxFit.cover,
            errorBuilder: (ctx, error, stackTrace) {
              Future.delayed(
                Duration.zero,
                () => setState(() => canLoadImage = false),
              );
              return Container();
            },
          )
        : FallbackProductImage(
            width: SizeConfig.screenWidth,
            height: SizeConfig.getHeightPercentage(30),
            alignment: Alignment.center,
            overlay: Colors.black26,
            style: productCardPriceStyle,
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
  return await showDialog<bool>(
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
