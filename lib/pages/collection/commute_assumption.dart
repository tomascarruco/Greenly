import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenly/assumptions.dart';
import 'package:provider/provider.dart';

typedef MenuEntry = DropdownMenuEntry<String>;

final List<String> transporationList = <String>[
  'Car',
  'Electric Car',
  'SUV',
  'Bus',
  'Subway',
  'Train',
];

class _NewCommuteAssumptionState extends State<NewCommuteAssumption> {
  @override
  Widget build(BuildContext context) {
    var textTheme = TextTheme.of(context);

    final menuEntries = UnmodifiableListView<MenuEntry>(
      transporationList.map(
        (String name) => MenuEntry(value: name, label: name),
      ),
    );

    List<String> frequencyList = Frequency.values
        .map((Frequency f) => f.name)
        .toList();

    final frequencyEntries = UnmodifiableListView<MenuEntry>(
      Frequency.values.map(
        (Frequency f) => MenuEntry(
          value: f.name,
          // Capitalize the name of the entry item
          label: f.name[0].toUpperCase() + f.name.substring(1),
        ),
      ),
    );

    final assumpCategory = TextEditingController();
    final assumpFrequency = TextEditingController();
    final assumpCount = TextEditingController();
    final assumpValue = TextEditingController();

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
                Text('Transport Assumption', style: textTheme.titleMedium),
                Text(
                  'How do you travel the distance.',
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
            SizedBox(),
            // The What?
            DropdownMenu(
              controller: assumpCategory,
              label: Text('Transport Category'),
              initialSelection: transporationList.first,
              onSelected: (String? value) {},
              dropdownMenuEntries: menuEntries,
              expandedInsets: EdgeInsets.zero,
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            // How much?
            TextField(
              controller: assumpValue,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9]+[,.]{0,1}[0-9]*'),
                ),
                TextInputFormatter.withFunction(
                  (oldValue, newValue) => newValue.copyWith(
                    text: newValue.text.replaceAll(',', '').replaceAll('.', ''),
                  ),
                ),
                TextInputFormatter.withFunction(
                  (oldValue, newValue) =>
                      newValue.copyWith(text: '${newValue.text} Km'),
                ),
              ],
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(),
                hintText: '100Km',
                label: Text('Distance Travelled (Km)'),
                alignLabelWithHint: true,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            Row(
              spacing: 10,
              children: [
                // How Offten?
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: assumpCount,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]+[,.]{0,1}[0-9]*'),
                      ),
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) => newValue.copyWith(
                          text: newValue.text
                              .replaceAll(',', '')
                              .replaceAll('.', ''),
                        ),
                      ),
                    ],
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                      hintText: '4',
                      label: Text('Count'),
                      alignLabelWithHint: true,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: DropdownMenu(
                    controller: assumpFrequency,
                    label: Text('Frequency'),
                    initialSelection: frequencyList.first,
                    onSelected: (String? value) {},
                    dropdownMenuEntries: frequencyEntries,
                    expandedInsets: EdgeInsets.zero,
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),
            FilledButton(
              onPressed: () async {
                Provider.of<AssumptionsModel>(context, listen: false).add(
                  TransportAssumption<double>(
                    assumpLabel: assumpCategory.text.trim(),
                    assumpValue: double.parse(
                      assumpValue.text.trim().substring(
                        0,
                        assumpValue.text.length - 4,
                      ),
                    ),
                    frequency: Frequency.from(assumpFrequency.text),
                    assumCount: int.parse(assumpCount.text.trim()),
                  ),
                );
                Navigator.of(context).pop();
                // debugPrint('Assum value: $assumpValue');
              },
              child: Text('Add Assumption'),
            ),
          ],
        ),
      ),
    );
  }
}

class NewCommuteAssumption extends StatefulWidget {
  const NewCommuteAssumption({super.key});

  @override
  State<StatefulWidget> createState() => _NewCommuteAssumptionState();
}
