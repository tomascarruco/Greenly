import 'package:flutter/material.dart';
import 'package:greenly/components/app_bottom_bar.dart';
import 'package:greenly/components/app_top_bar.dart';
import 'package:greenly/main.dart';
import 'package:greenly/pages/authentication.dart';
import 'package:greenly/pages/settings.dart';

class BasePageLayout extends StatelessWidget {
  final Widget body;

  final void Function()? floatingBtnAction;
  final String? floatingBtnTooltip;
  final IconData? floatingBtnIcon;
  final bool? hasActionButton;

  const BasePageLayout({
    this.floatingBtnIcon,
    this.floatingBtnAction,
    this.floatingBtnTooltip,
    required this.hasActionButton,
    required this.body,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var textTheme = TextTheme.of(context);
    var themeColorScheme = Theme.of(context).colorScheme;

    var floatingActionButton = FloatingActionButton(
      onPressed: floatingBtnAction,
      tooltip: floatingBtnTooltip,
      backgroundColor: themeColorScheme.secondaryContainer,
      elevation: 0,
      child: floatingBtnIcon != null ? Icon(floatingBtnIcon!) : null,
    );

    return Scaffold(
      // --- APP Top Bar and Navigation!
      appBar: const AppTopBar(),
      // --- APP Bottom Bar and action button
      bottomNavigationBar: AppBarBottom(),
      // --- Floating Button
      floatingActionButton: hasActionButton != null
          ? floatingActionButton
          : null,
      floatingActionButtonLocation: hasActionButton != null
          ? FloatingActionButtonLocation.endContained
          : null,
      // --- Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 130,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: themeColorScheme.secondaryContainer,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 5,
                  children: [
                    Icon(Icons.list),
                    Text('Menu', style: textTheme.titleLarge),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Row(
                spacing: 10,
                children: [const Icon(Icons.settings), const Text('Settings')],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const SettingsPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Row(
                spacing: 10,
                children: [
                  const Icon(Icons.logout_rounded),
                  const Text('Log-out'),
                ],
              ),
              onTap: () async {
                try {
                  await supabase.auth.signOut();
                } catch (err) {
                  debugPrint('Failed to logout the user');
                } finally {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('See you soon!')));

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const AuthenticationPage(),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
      // --- Body
      body: body,
    );
  }
}
