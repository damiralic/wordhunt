import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wordhunt/providers/auth.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  String? errorMessage = "";
  bool isLogin = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget title() {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(isLogin ? 'LOGIN' : 'REGISTER',
            style: TextStyle(
                color: Color.fromARGB(255, 186, 188, 235), fontSize: 40)),
      ),
      centerTitle: true,
    );
  }

  Widget entryField(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
        ),
      ),
    );
  }

  Widget errorMessageText() {
    return Text(errorMessage ?? "");
  }

  Widget loginButton() {
    return ElevatedButton(
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget loginOrRegisterButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(isLogin ? 'Register' : 'Login'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title(),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            entryField('Email', emailController),
            entryField('Password', passwordController),
            errorMessageText(),
            loginButton(),
            loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}
