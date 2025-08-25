import 'package:flutter/material.dart';

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
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var floatingActionButton = FloatingActionButton(
      onPressed: () {},
      tooltip: 'Available Actions',
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      elevation: 0,
      child: Icon(Icons.add),
    );

    var pageBody = Center(
      child: Builder(
        builder: (context) {
          return Column(
            children: [const SizedBox(height: 20), Text('Hello World!')],
          );
        },
      ),
    );

    // var appBar = AppBar(title: const Text('My Home Page'));

    return Scaffold(
      // --- APP Top Bar and Navigation
      appBar: const AppBarTop(),
      // --- APP Bottom Bar and action button
      bottomNavigationBar: AppBottomAppBar(),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      // --- Material APP Body
      body: pageBody,
    );
  }
}

class AppBarTop extends StatelessWidget implements PreferredSizeWidget {
  const AppBarTop({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = TextTheme.of(context);
    var title = Text('Greenly', style: textTheme.headlineLarge);

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

class AppBottomAppBar extends StatelessWidget {
  const AppBottomAppBar({super.key});

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
