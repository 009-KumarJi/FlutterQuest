// path: /pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:photugram/services/firebase_service.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double _deviceHeight, _deviceWidth;

  bool _isLoading = false;

  final GlobalKey<FormState> _credentialFormKey = GlobalKey<FormState>();

  FirebaseService? _firebaseService;

  String? _email, _password;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.05,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _titleWidget(),
                _credentialForm(),
                _loginButton(),
                _createAccountWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return const Text(
      'PhotuGram',
      style: TextStyle(
        color: Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _loginButton() {
    return _isLoading
        ? const CircularProgressIndicator() // Show spinner while loading
        : MaterialButton(
            onPressed: _loginUser,
            minWidth: _deviceWidth * 0.70,
            height: _deviceHeight * 0.06,
            color: Colors.redAccent,
            child: const Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),
          );
  }

  Widget _credentialForm() {
    return Container(
      height: _deviceHeight * 0.2,
      child: Form(
        key: _credentialFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _emailTextField(),
            _passTextField(),
          ],
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "Email..."),
      onSaved: (value) {
        setState(() {
          _email = value;
        });
      },
      validator: (value) {
        bool isValidEmail =
            RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                .hasMatch(value!);
        return isValidEmail ? null : "Please Enter a Valid Email...";
      },
    );
  }

  Widget _passTextField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
        hintText: "Password...",
      ),
      onSaved: (_value) {
        _password = _value;
      },
    );
  }

  Widget _createAccountWidget() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'register'),
      child: const Text(
        'Create Account',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 15,
          fontWeight: FontWeight.w200,
        ),
      ),
    );
  }

  void _loginUser() async {
    if (!_credentialFormKey.currentState!.validate()) return;
    _credentialFormKey.currentState!.save(); // to invoke onSaved
    _setLoading(true);
    bool _result = await _firebaseService!.loginUser(email: _email!, password: _password!);
    _setLoading(false);
    _result
        ? Navigator.popAndPushNamed(context, 'home')
        : showErrorDialog(context);
  }

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value; // Start/Stop showing spinner
    });
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          backgroundColor: Colors.red,
          title: Text(
            'Login Failed',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          content: Text('Incorrect email or password. Please try again.'),
        );
      },
    );
    Future.delayed(const Duration(seconds: 3), () => Navigator.popAndPushNamed(context, 'login'));
  }

}
