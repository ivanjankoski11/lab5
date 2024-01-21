import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mis_lab3/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signIn(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (err) {
      setState(() {
        errorMessage = err.message;
      });
    }
  }

  Future<void> signUpWithEmailAndPassword() async {
    try {
      await Auth().singUp(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (err) {
      setState(() {
        errorMessage = err.message;
      });
    }
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: title),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed:
            isLogin ? signInWithEmailAndPassword : signUpWithEmailAndPassword,
        child: Text(isLogin ? 'Login' : 'Register'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login page"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _entryField('email', _emailController),
            _entryField('password', _passwordController),
            _submitButton()
          ],
        ),
      ),
    );
  }
}
