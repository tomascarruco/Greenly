import 'package:flutter/material.dart';

// import 'package:greenly/pages/home.dart';
import 'package:greenly/pages/authentication.dart';
import 'package:greenly/pages/home.dart';

void main() {
  const appTitle = 'greenly';

  runApp(const MainApp(appTitle));
}

class MainApp extends StatelessWidget {
  final String appTitle;

  const MainApp(this.appTitle, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
          surface: Color.fromRGBO(246, 250, 245, 100),
        ),
        textTheme: TextTheme(
          headlineSmall: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w700,
            fontSize: 26,
          ),
          titleLarge: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
          bodyMedium: const TextStyle(fontSize: 16),
          bodySmall: const TextStyle(fontSize: 14),
        ),
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    var themeColorScheme = Theme.of(context).colorScheme;

    var floatingActionButton = FloatingActionButton(
      onPressed: () {},
      tooltip: 'Available Actions',
      backgroundColor: themeColorScheme.secondaryContainer,
      elevation: 0,
      child: Icon(Icons.add),
    );

    return Scaffold(
      // --- APP Top Bar and Navigation
      appBar: const AppTopBar(),
      // --- APP Bottom Bar and action button
      bottomNavigationBar: AppBarBottom(),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      // --- Material APP Body
      body: HomePage(),
    );
  }
}

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = TextTheme.of(context);
    var title = Text('Greenly', style: textTheme.headlineSmall);

    return AppBar(
      title: title,
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {},
        icon: Icon(Icons.menu),
        iconSize: 32,
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
