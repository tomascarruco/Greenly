import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = TextTheme.of(context);
    var title = Text('Greenly', style: textTheme.headlineSmall);

    return AppBar(
      title: title,
      backgroundColor: Colors.white,
      animateColor: true,
      centerTitle: true,
      elevation: 0,

      leading: Builder(
        builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu),
            iconSize: 32,
          );
        },
      ),
      actions: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.lightGreen.shade100,
          child: const Text('A'),
        ),
      ],
      actionsPadding: const EdgeInsetsGeometry.all(10),
      actionsIconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
