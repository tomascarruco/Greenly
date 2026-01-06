import 'package:flutter/material.dart';
import 'package:greenly/pages/assumptions.dart';

class FoodAssumption<T> implements Assumption<T> {
  final String _assumpLabel;
  final T _assumpValue;
  final Frequency _assumFrequency;
  final int _assumpCount;
  final double _assumpGhgEmissions;

  const FoodAssumption({
    required int assumCount,
    required String assumpLabel,
    required T assumpValue,
    required Frequency frequency,
    double ghgEmission = 0,
  }) : _assumpValue = assumpValue,
       _assumpLabel = assumpLabel,
       _assumFrequency = frequency,
       _assumpCount = assumCount,
       _assumpGhgEmissions = ghgEmission;

  @override
  double ghgValue() {
    return _assumpGhgEmissions;
  }

  @override
  int count() {
    return _assumpCount;
  }

  @override
  Frequency frequency() {
    return _assumFrequency;
  }

  @override
  String label() {
    return _assumpLabel;
  }

  @override
  T value() {
    return _assumpValue;
  }

  @override
  Widget toWidget() {
    var cardShape = RoundedRectangleBorder(
      side: BorderSide(
        color: Colors.grey.shade300,
        width: 1,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    );

    // const Widget svgI = SvgPicture(
    //   AssetBytesLoader('assets/icons/svg/beef.svg.vec'),
    //   colorFilter: ColorFilter.mode(Colors.lightGreen, BlendMode.srcIn),
    // );

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: cardShape,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 18,
              children: [
                // Emissions and Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('$_assumpCount times ${_assumFrequency.name}'),
                    Row(
                      spacing: 6,
                      children: [
                        Text(
                          '$_assumpValue ${_assumpCount > 1 ? "portions" : "portion"} of',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '$_assumpLabel',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // Emissions delta indicator
            Row(
              children: [
                Builder(
                  builder: (context) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${_assumpGhgEmissions.toStringAsFixed(2)} Kg',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Co2e',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Map<String, Object> toMap() {
    return {
      'categorie': _assumpLabel,
      'count': _assumpCount,
      'frequency': _assumFrequency.name,
      'proportion_size': _assumpValue as Object,
      // 'inserted_at': DateTime.now().toUtc(),
      // 'ghg': _assumpGhgEmissions,
    };
  }

  factory FoodAssumption.fromMap(Map<String, dynamic> data) {
    return switch (data) {
      {
        'categorie': String categorie,
        'count': int count,
        'frequency': String frequency,
        'proportion_size': String proportionSize,
        'ghg_weekly': dynamic ghg,
      } =>
        FoodAssumption(
          assumCount: count,
          assumpLabel: categorie,
          assumpValue: proportionSize as T,
          frequency: Frequency.from(frequency),
          ghgEmission: double.parse(ghg.toString()),
        ),
      _ => throw const FormatException(
        'Failed to parse FoodAssumption from data (DB).',
      ),
    };
  }
}
