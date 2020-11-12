import 'package:flutter/widgets.dart';

import '../constants.dart';

class FallbackProductImage extends StatelessWidget {
  final double height, width;
  final Alignment alignment;
  final TextStyle style;
  final Color overlay;
  const FallbackProductImage({
    @required this.height,
    @required this.width,
    this.alignment,
    this.style,
    this.overlay,
  })  : assert(height != null),
        assert(width != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(fallbackImagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(16),
        alignment: alignment ?? Alignment.topCenter,
        color: overlay,
        child: Text(
          'Desculpe, não conseguimos carregar a imagem deste produto',
          style: style,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
