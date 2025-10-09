import 'package:flutter/material.dart';
import 'package:greenly/components/base_layout.dart';
import 'package:greenly/main.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = TextTheme.of(context);

    const scrollViewEdgeInsets = EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 12,
    );

    return BasePageLayout(
      floatingBtnIcon: Icons.add,
      floatingBtnTooltip: 'Available Actions',
      // --- Body
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(Icons.settings_outlined)),
                Tab(icon: Icon(Icons.candlestick_chart_outlined)),
                Tab(icon: Icon(Icons.person_outlined)),
              ],
            ),
            Expanded(
              child: Padding(
                padding: scrollViewEdgeInsets,
                child: TabBarView(
                  children: [
                    _buildBaseSettingsSection(textTheme),
                    _buildBaseAssumptionsSection(textTheme),
                    SingleChildScrollView(child: const Text('AAA')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      hasActionButton: false,
    );
  }

  SingleChildScrollView _buildBaseAssumptionsSection(TextTheme textTheme) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        spacing: 6,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 4,
            children: [
              Text('Base Assumptions', style: textTheme.titleMedium),
              Text(
                'The base values of your day-to-day.',
                style: textTheme.bodyMedium,
              ),
            ],
          ),
          _spacer(),
          Divider(height: 2, color: Colors.grey.shade300),
          _spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 4,
            children: [
              Text('Commute', style: textTheme.titleSmall),
              _spacer(h: 4),
            ],
          ),
          _spacer(),
          Consumer<AssumptionsModel>(
            builder:
                (
                  BuildContext context,
                  AssumptionsModel assumptions,
                  Widget? child,
                ) {
                  var children = assumptions
                      .getAssumptionsPerType<TransportationAssumption>();

                  var a = List<Widget>.generate(children.length, (int index) {
                    return Container(
                      width: 500,
                      height: 50,
                      color: Colors.amber.shade500,

                      child: Text(children[index].label()),
                    );
                  });

                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FilledButton(
                        onPressed: () {
                          Provider.of<AssumptionsModel>(
                            context,
                            listen: false,
                          ).add(
                            TransportationAssumption<int>(
                              assumpLabel: 'Super',
                              assumpValue: 12,
                            ),
                          );
                        },
                        child: const Text('Add new Assumption'),
                      ),
                      Column(children: a),
                    ],
                  );
                },
          ),
        ],
      ),
    );
  }

  SizedBox _spacer({double? h}) => (SizedBox(height: h ?? 4.0));

  SingleChildScrollView _buildBaseSettingsSection(TextTheme textTheme) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        spacing: 6,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 4,
            children: [
              Text('Base Settings', style: textTheme.titleMedium),
              Text(
                'Notifications and functionality.',
                style: textTheme.bodyMedium,
              ),
            ],
          ),
          Container(),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ToggleOption(
                optionIcon: Icons.notifications_rounded,
                active: true,
                title: 'Receive Notifications',
                description: 'Set to OFF sends only essential notifications.',
              ),
              ToggleOption(
                optionIcon: Icons.calendar_month_rounded,
                active: false,
                title: 'Reminders',
                description: 'Helps you achieve your goals.',
              ),
              ToggleOption(
                optionIcon: Icons.gamepad_rounded,
                active: true,
                action: (bool newValue) {},
                title: 'Ai Gamification',
                description: 'Gamify your tasks, and progress tracking.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ToggleOption extends StatelessWidget {
  final IconData optionIcon;
  final bool active;
  final String title;
  final String? description;
  final void Function(bool)? action;

  const ToggleOption({
    required this.optionIcon,
    required this.active,
    required this.title,
    super.key,
    this.description,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    var textTheme = TextTheme.of(context);

    var cardShape = RoundedRectangleBorder(
      side: BorderSide(
        color: Colors.grey.shade100,
        width: 0,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    );

    return Card(
      shape: cardShape,
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: EdgeInsetsGeometry.all(18),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 10,
          children: [
            Icon(optionIcon, size: 28),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleSmall),
                  description != null
                      ? Text(description!, style: textTheme.bodySmall)
                      : Container(),
                ],
              ),
            ),
            Switch(value: active, onChanged: action),
          ],
        ),
      ),
    );
  }
}
