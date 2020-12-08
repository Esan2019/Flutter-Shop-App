import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../widgets/rounded_button.dart';
import '../../size_config.dart';
import '../../routes_handler.dart';
import '../../constants.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3200),
    );

    controller.addStatusListener(repeatAnimationWhenCompleted);
    final delayToStartAnimation = Duration(seconds: 1);
    Timer(delayToStartAnimation, () => controller.forward());

    super.initState();
  }

  @override
  void dispose() {
    controller.removeStatusListener(repeatAnimationWhenCompleted);
    controller.dispose();
    super.dispose();
  }

  void repeatAnimationWhenCompleted(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return WillPopScope(
      onWillPop: () async {
        controller.stop();
        return true;
      },
      child: ListenableProvider<AnimationController>.value(
        value: controller,
        child: Scaffold(
          body: SafeArea(child: Body()),
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacer(),
          Text(shopName, style: Theme.of(context).textTheme.headline3),
          Text('Seja bem-vindo(a) ao nosso aplicativo'),
          Animation(),
          Text(
            'Para prosseguir, escolha uma opção abaixo:',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          RoundedButton(
            text: 'Já tenho uma conta e desejo entrar',
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                authRoute,
                arguments: false,
              );
            },
          ),
          RoundedButton(
            text: 'Sou novo(a) e desejo criar uma conta',
            color: Theme.of(context).primaryColor,
            textColor: Colors.black87,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                authRoute,
                arguments: true,
              );
            },
          ),
          Spacer(),
          FlatButton(
            child: Text(
              'Quero explorar o catálogo sem criar uma conta',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(homeRoute);
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class Animation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.getHeightPercentage(30),
      width: SizeConfig.getWidthPercentage(80),
      child: Lottie.asset(
        'assets/animations/group-of-people.json',
        controller: Provider.of<AnimationController>(context, listen: false),
        frameRate: FrameRate(30),
      ),
    );
  }
}
