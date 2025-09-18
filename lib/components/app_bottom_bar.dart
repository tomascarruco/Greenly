import 'package:flutter/material.dart';

class AppBarBottom extends StatelessWidget {
  const AppBarBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: 'Open Search Menu',
              icon: const Icon(Icons.search),
              iconSize: 32,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
