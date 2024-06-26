import 'package:flutter/material.dart';
import 'package:wordhunt/pages/home_page.dart';
import 'package:wordhunt/pages/login_register_page.dart';
import 'package:wordhunt/providers/auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return HomePage();
        } else {
          return LoginRegister();
        }
      },
    );
  }
}
