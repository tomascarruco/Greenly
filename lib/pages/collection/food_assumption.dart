import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:greenly/assumptions.dart';
import 'package:provider/provider.dart';

typedef MenuEntry = DropdownMenuEntry<String>;

final List<String> foodCategorieList = <String>[
  'Beef',
  'Poultry',
  'Pork',
  'Milk/Dary',
  'Fish',
  'Eggs',
  'Bread/grain',
];

final List<String> proportionSizeList = <String>['Small', 'Medium', 'Large'];

class _NewFoodAssumptionState extends State<NewFoodAssumption> {
  double _currentSliderValue = 7;
  final _foodCategoryController = TextEditingController();
  final _proportionSizeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var textTheme = TextTheme.of(context);

    var cardShape = RoundedRectangleBorder(
      side: BorderSide(
        color: Colors.grey.shade300,
        width: 2,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    );

    final menuEntries = UnmodifiableListView<MenuEntry>(
      foodCategorieList.map(
        (String name) => MenuEntry(
          value: name,
          label: name[0].toUpperCase() + name.substring(1),
        ),
      ),
    );

    final proportionEntries = UnmodifiableListView<MenuEntry>(
      proportionSizeList.map(
        (String name) => MenuEntry(value: name, label: name),
      ),
    );

    // List<String> frequencyList = Frequency.values
    //     .map((Frequency f) => f.name)
    //     .toList();

    // final frequencyEntries = UnmodifiableListView<MenuEntry>(
    //   Frequency.values.map(
    //     (Frequency f) => MenuEntry(
    //       value: f.name,
    //       // Capitalize the name of the entry item
    //       label: f.name[0].toUpperCase() + f.name.substring(1),
    //     ),
    //   ),
    // );

    var inputDecorationTheme = InputDecorationTheme(
      border: OutlineInputBorder(),
      fillColor: Colors.white,
      filled: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('New Assumption'),
        backgroundColor: Colors.white,
        animateColor: true,
        centerTitle: true,
        elevation: 0,

        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            );
          },
        ),
        actionsPadding: const EdgeInsetsGeometry.all(10),
        actionsIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Column(
          spacing: 15,
          // mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 4,
              children: [
                Text('Food Assumption', style: textTheme.titleMedium),
                Text(
                  'What do you eat, and how offten.',
                  style: textTheme.bodyMedium,
                ),
              ],
            ),

            // The What?
            Card(
              color: Colors.white,
              elevation: 0,
              shape: cardShape,
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  vertical: 22,
                  horizontal: 22,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      'How are your habits like?',
                      style: textTheme.titleSmall,
                    ),
                    Text(
                      'At least ${_currentSliderValue.round()} times per week.',
                      style: textTheme.labelLarge,
                    ),
                    Slider(
                      value: _currentSliderValue,
                      max: 20,
                      divisions: 20,
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                      label: '${_currentSliderValue.round()}x',
                    ),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          flex: 3,
                          child: DropdownMenu(
                            controller: _foodCategoryController,
                            label: Text('Food Category'),
                            initialSelection: foodCategorieList.first,
                            onSelected: (String? value) {},
                            dropdownMenuEntries: menuEntries,
                            expandedInsets: EdgeInsets.zero,
                            inputDecorationTheme: inputDecorationTheme,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: DropdownMenu(
                            controller: _proportionSizeController,
                            label: Text('Proportion Size'),
                            initialSelection: proportionSizeList.first,
                            onSelected: (String? value) {},
                            dropdownMenuEntries: proportionEntries,
                            expandedInsets: EdgeInsets.zero,
                            inputDecorationTheme: inputDecorationTheme,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // How much?
            FilledButton(
              onPressed: () async {
                Provider.of<AssumptionsModel>(context, listen: false).add(
                  FoodAssumption<String>(
                    assumCount: _currentSliderValue.toInt(),
                    assumpLabel: _foodCategoryController.text,
                    assumpValue: _proportionSizeController.text,
                    frequency: Frequency.weekly,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: Text('Add Assumption'),
            ),
          ],
        ),
      ),
    );
  }
}

class NewFoodAssumption extends StatefulWidget {
  const NewFoodAssumption({super.key});

  @override
  State<StatefulWidget> createState() => _NewFoodAssumptionState();
}
