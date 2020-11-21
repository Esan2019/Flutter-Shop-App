import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import '../../widgets/rounded_button.dart';
import '../../size_config.dart';
import '../../constants.dart';
import '../../routes_handler.dart';

class AuthScreen extends StatelessWidget {
  final bool isRegistering;
  const AuthScreen(this.isRegistering);

  void goBackToWelcomeScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(welcomeRoute);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        goBackToWelcomeScreen(context);
        return true;
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.arrow_back),
          onPressed: () => goBackToWelcomeScreen(context),
        ),
        body: Container(
          height: SizeConfig.screenHeight + 24,
          width: SizeConfig.screenWidth,
          child: Stack(
            children: [
              BackgroundAnimation(),
              Positioned(
                top: SizeConfig.getHeightPercentage(10),
                left: 10,
                right: 10,
                child: Column(
                  children: [
                    Text(
                      isRegistering ? welcomeOnBoardText : welcomeBackText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: SizeConfig.getHeightPercentage(15)),
                    AuthForm(isRegistering, context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BackgroundAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight + 24,
      width: SizeConfig.screenWidth,
      child: Lottie.asset(
        'assets/animations/floating-in-balloons.json',
        fit: BoxFit.cover,
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
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() {
    // TODO: implement submitForm
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
                onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 15),
              generateFormField(
                text: widget.isRegistering
                    ? 'Crie uma senha segura'
                    : 'Digite sua senha',
                onFieldSubmitted: (_) {
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
                  onFieldSubmitted: (_) => _submitForm(),
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
    TextInputType keyboardType,
    TextInputAction textInputAction,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.transparent),
    );

    return Material(
      type: MaterialType.card,
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      child: TextFormField(
        obscureText: obscureText,
        focusNode: focusNode,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          filled: true,
          border: InputBorder.none,
          fillColor: Theme.of(context).primaryColor,
          hintText: text,
          enabledBorder: border,
          focusedBorder: border,
        ),
      ),
    );
  }
}
