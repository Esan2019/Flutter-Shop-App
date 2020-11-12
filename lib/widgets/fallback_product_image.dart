import 'package:flutter/widgets.dart';

import '../constants.dart';

class FallbackProductImage extends StatelessWidget {
  final double height, width;
  final Alignment alignment;
  final TextStyle style;
  const FallbackProductImage({
    @required this.height,
    @required this.width,
    this.alignment,
    this.style,
  })  : assert(height != null),
        assert(width != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: height,
      width: width,
      alignment: alignment ?? Alignment.topCenter,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(fallbackImagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Text(
        'Desculpe, não conseguimos carregar a imagem deste produto',
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }
}
