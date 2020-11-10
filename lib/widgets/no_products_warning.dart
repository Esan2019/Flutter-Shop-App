import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class NoProductsWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Lottie.asset('assets/animations/404.json'),
        ),
        Expanded(
          child: Text(
            'Nenhum produto encontrado',
            style: Theme.of(context).textTheme.headline4.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
