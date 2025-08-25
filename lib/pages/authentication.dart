import 'package:flutter/material.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = TextTheme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: List<Widget>.generate(200, (int id) {
          return Text('Hello $id');
        }),
      ),
    );
  }
}
