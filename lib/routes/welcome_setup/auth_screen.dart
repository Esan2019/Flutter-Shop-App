import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../widgets/rounded_button.dart';
import '../../size_config.dart';
import '../../constants.dart';
import '../../routes_handler.dart';
import '../../providers/auth.dart';
import '../../exceptions/firebase_exception.dart';
import '../../exceptions/http_exception.dart';

class AuthScreen extends StatefulWidget {
  final bool isRegistering;
  const AuthScreen(this.isRegistering);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  void goBackToWelcomeScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(welcomeRoute);
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 12),
    );

    controller.addStatusListener(restartAnimationWhenCompleted);

    final delayToStartAnimation = Duration(seconds: 1);
    Timer(delayToStartAnimation, () => controller.forward());

    super.initState();
  }

  @override
  void dispose() {
    controller.removeStatusListener(restartAnimationWhenCompleted);
    controller.dispose();
    super.dispose();
  }

  void restartAnimationWhenCompleted(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.stop();
        goBackToWelcomeScreen(context);
        return true;
      },
      child: ListenableProvider<AnimationController>.value(
        value: controller,
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Icon(Icons.arrow_back),
            onPressed: () => goBackToWelcomeScreen(context),
          ),
          body: Container(
            height: SizeConfig.screenHeight + SizeConfig.mediaQuery.padding.top,
            width: SizeConfig.screenWidth,
            child: Stack(
              overflow: Overflow.visible,
              children: [
                BackgroundAnimation(),
                Positioned(
                  top: SizeConfig.getHeightPercentage(10),
                  left: 10,
                  right: 10,
                  child: Column(
                    children: [
                      Text(
                        widget.isRegistering
                            ? welcomeOnBoardText
                            : welcomeBackText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: SizeConfig.getHeightPercentage(15)),
                      AuthForm(widget.isRegistering, context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: SizeConfig.screenHeight + SizeConfig.mediaQuery.padding.top,
        minWidth: SizeConfig.screenWidth,
      ),
      child: Lottie.asset(
        'assets/animations/floating-in-balloons.json',
        fit: BoxFit.cover,
        controller: Provider.of<AnimationController>(context, listen: false),
        frameRate: FrameRate(30),
      ),
    );
  }
}

class AuthForm extends StatefulWidget {
  final bool isRegistering;
  final BuildContext pageContext;
  AuthForm(this.isRegistering, this.pageContext);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _confirmPasswordFocusNode = FocusNode();
  String email, confirmPassword;

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final isFormValid = _formKey.currentState.validate();
    final authProvider = Provider.of<Auth>(context, listen: false);

    if (!isFormValid) return;

    _formKey.currentState.save();

    try {
      if (widget.isRegistering) {
        await authProvider.signUp(email, _passwordController.text);
      } else {
        await authProvider.signIn(email, _passwordController.text);
      }

      Navigator.of(context).pushReplacementNamed(homeRoute);
    } on FirebaseException catch (error) {
      String message =
          'Ocorreu um erro inesperado em nossos servidores. Tente novamente mais tarde.';
      final errorMessage = error.toString();

      if (errorMessage.contains('MISSING_EMAIL') ||
          errorMessage.contains('MISSING_PASSWORD') ||
          errorMessage.contains('EMAIL_NOT_FOUND') ||
          errorMessage.contains('INVALID_PASSWORD')) {
        message =
            'O endereço de email ou a senha que você digitou estão incorretos, ou não pertencem a nenhuma conta ainda.';
      } else if (errorMessage.contains('INVALID_EMAIL')) {
        message =
            'Você precisa fornecer um endereço de email válido, caso contrário, não conseguiremos entrar em contato com você.';
      } else if (errorMessage.contains('WEAK_PASSWORD')) {
        message =
            'Por motivos de segurança, a sua senha precisa ter no mínimo 6 caracteres.';
      } else if (errorMessage.contains('EMAIL_EXISTS')) {
        message =
            'O endereço de email que você informou ($email) já está associado à outra conta.';
      }
      showAlertDialog(message);
    } on HttpException catch (error) {
      showAlertDialog(error.toString());
    }
  }

  String validatePassword(String password) {
    if (password.length < 6) {
      return 'A senha precisa ter pelo menos 6 caracteres.';
    } else {
      return null;
    }
  }

  String validateEmail(String email) {
    if (!email.contains('@')) {
      return 'Você precisa fornecer um email válido.';
    } else {
      return null;
    }
  }

  void showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: Text(message, textAlign: TextAlign.center),
          actions: [
            FlatButton(
              child: Text(
                'Entendi',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              generateFormField(
                text: widget.isRegistering
                    ? 'Digite seu melhor email'
                    : 'Digite seu email',
                validator: validateEmail,
                onSaved: (value) => email = value,
                onFieldSubmitted: (value) {
                  _passwordFocusNode.requestFocus();
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 15),
              generateFormField(
                text: widget.isRegistering
                    ? 'Crie uma senha segura'
                    : 'Digite sua senha',
                validator: validatePassword,
                controller: _passwordController,
                onFieldSubmitted: (value) {
                  if (widget.isRegistering) {
                    _confirmPasswordFocusNode.requestFocus();
                  } else {
                    _submitForm();
                  }
                },
                textInputAction: widget.isRegistering
                    ? TextInputAction.next
                    : TextInputAction.done,
                focusNode: _passwordFocusNode,
                obscureText: true,
              ),
              SizedBox(height: 15),
              if (widget.isRegistering)
                generateFormField(
                  text: 'Digite a senha novamente, só pra ter certeza',
                  textInputAction: TextInputAction.done,
                  focusNode: _confirmPasswordFocusNode,
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Ops, parece que as duas senhas são diferentes. Tente novamente.';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) => confirmPassword = value,
                  onFieldSubmitted: (_) {
                    _submitForm();
                  },
                ),
              if (widget.isRegistering) SizedBox(height: 15),
              RoundedButton(
                text: widget.isRegistering
                    ? 'Tudo certo, pode criar a minha conta!'
                    : 'Pronto, vamos entrar!',
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget generateFormField({
    String text,
    bool obscureText = false,
    FocusNode focusNode,
    Function(String) onFieldSubmitted,
    onSaved,
    String Function(String) validator,
    TextInputType keyboardType,
    TextInputAction textInputAction,
    TextEditingController controller,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.transparent),
    );

    return TextFormField(
      obscureText: obscureText,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      onFieldSubmitted: onFieldSubmitted,
      controller: controller,
      onSaved: onSaved,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        border: InputBorder.none,
        fillColor: Theme.of(context).primaryColor,
        errorStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        errorBorder: border,
        focusedErrorBorder: border,
        hintText: text,
        enabledBorder: border,
        focusedBorder: border,
      ),
    );
  }
}
