import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenly/assumptions.dart';
import 'package:provider/provider.dart';

typedef MenuEntry = DropdownMenuEntry<String>;

class _NewAssumptionState extends State<NewAssumption> {
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

    final _assumpCategory = TextEditingController();
    final _assumpFrequency = TextEditingController();
    final _assumpCount = TextEditingController();
    final _assumpValue = TextEditingController();

    // ---------------------------------
    //     Provider.of<AssumptionsModel>(
    //       context,
    //       listen: false,
    //     ).add(
    //       TransportationAssumption<int>(
    //         assumpLabel: 'Super',
    //         assumpValue: 12,
    //         frequency: Frequency.daily,
    //       ),
    //     );
    //   },
    //   child: Text('Create New Entry'),
    // ),

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
              controller: _assumpCategory,
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
              controller: _assumpValue,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9]+[,.]{0,1}[0-9]*'),
                ),
                TextInputFormatter.withFunction(
                  (oldValue, newValue) => newValue.copyWith(
                    text: newValue.text.replaceAll(',', '.'),
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
                    controller: _assumpCount,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]+[,.]{0,1}[0-9]*'),
                      ),
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) => newValue.copyWith(
                          text: newValue.text.replaceAll(',', '.'),
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
                    controller: _assumpFrequency,
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
              onPressed: () {
                Provider.of<AssumptionsModel>(context, listen: false).add(
                  TransportationAssumption<double>(
                    assumpLabel: _assumpCategory.text.trim(),
                    assumpValue: double.parse(
                      _assumpValue.text.trim().substring(
                        0,
                        _assumpValue.text.length - 4,
                      ),
                    ),
                    frequency: Frequency.from(_assumpFrequency.text),
                    assumCount: int.parse(_assumpCount.text.trim()),
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

class NewAssumption extends StatefulWidget {
  const NewAssumption({super.key});

  @override
  State<StatefulWidget> createState() => _NewAssumptionState();
}
