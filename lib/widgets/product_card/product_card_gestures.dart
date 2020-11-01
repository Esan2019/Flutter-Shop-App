import 'package:flutter/material.dart';

import 'product_card.dart';

class ProductCardGestures extends StatelessWidget {
  final ValueKey<String> key;

  final Function onTap;
  final Function onDoubleTap;

  final Function onRightSwipe;
  final Widget rightSwipeBackground;

  final Function onLeftSwipe;
  final Widget leftSwipeBackground;

  final ProductCard child;

  ProductCardGestures({
    @required this.key,
    @required this.onTap,
    this.onDoubleTap,
    @required this.onRightSwipe,
    @required this.rightSwipeBackground,
    this.onLeftSwipe,
    this.leftSwipeBackground,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(key),
      direction: onLeftSwipe != null
          ? DismissDirection.horizontal
          : DismissDirection.startToEnd,
      confirmDismiss: (direction) async {
        switch (direction) {
          case DismissDirection.startToEnd:
            onRightSwipe();
            break;
          case DismissDirection.endToStart:
            onLeftSwipe();
            break;
          default:
            return false;
        }
        return false;
      },
      background: rightSwipeBackground,
      secondaryBackground: leftSwipeBackground,
      child: GestureDetector(
        child: child,
        onTap: onTap,
        onDoubleTap: onDoubleTap,
      ),
    );
  }
}
