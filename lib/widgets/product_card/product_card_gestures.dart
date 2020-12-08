import 'package:flutter/widgets.dart';

import 'package:lottie/lottie.dart';

import 'product_card.dart';

class ProductCardGestures extends StatefulWidget {
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
  _ProductCardGesturesState createState() => _ProductCardGesturesState();
}

class _ProductCardGesturesState extends State<ProductCardGestures>
    with SingleTickerProviderStateMixin {
  bool animationIsVisible = false;
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void showHeartAnimation(bool isFavorite) {
    if (isFavorite) {
      toggleAnimationVisibility();
      controller.forward(from: 0).whenCompleteOrCancel(() {
        controller.stop();
        toggleAnimationVisibility();
      });
    }
  }

  void toggleAnimationVisibility() {
    setState(() => animationIsVisible = !animationIsVisible);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.key),
      direction: widget.onLeftSwipe != null
          ? DismissDirection.horizontal
          : DismissDirection.startToEnd,
      confirmDismiss: (direction) async {
        switch (direction) {
          case DismissDirection.startToEnd:
            widget.onRightSwipe();
            break;
          case DismissDirection.endToStart:
            widget.onLeftSwipe();
            break;
          default:
            return false;
        }
        return false;
      },
      background: widget.rightSwipeBackground,
      secondaryBackground: widget.leftSwipeBackground,
      child: GestureDetector(
        child: Stack(
          children: [
            widget.child,
            if (animationIsVisible) Positioned(
              bottom: 0,
              top: 0,
              left: 0,
              right: 0,
              child: Lottie.asset(
                'assets/animations/add-to-favorites.json',
                frameRate: FrameRate(30),
                controller: controller,
              ),
            )
          ],
        ),
        onTap: widget.onTap,
        onDoubleTap: () => showHeartAnimation(widget.onDoubleTap()),
      ),
    );
  }
}
