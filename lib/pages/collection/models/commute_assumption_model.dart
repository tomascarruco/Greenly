import 'package:flutter/material.dart';
import 'package:greenly/pages/assumptions.dart';

class TransportAssumption<T> implements Assumption<T> {
  final String _assumpLabel;
  final T _assumpValue;
  final Frequency _assumFrequency;
  final int _assumpCount;
  final double _assumpGhgEmissions;

  const TransportAssumption({
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
  Map<String, Object> toMap() {
    return {
      'transport': _assumpLabel,
      'distance': _assumpValue as Object,
      'count': _assumpCount,
      'frequency': _assumFrequency.name,
      // 'ghg': _assumpGhgEmissions,
      // 'inserted_at': DateTime.now().toUtc(),
    };
  }

  @override
  double ghgValue() {
    return _assumpGhgEmissions;
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
  Frequency frequency() {
    return _assumFrequency;
  }

  @override
  int count() {
    return _assumpCount;
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

    // final IconData transportIcon;
    // switch (_assumpLabel) {
    //   case 'Sedan':
    //     transportIcon = Icons.directions_car_rounded;
    //   case 'SUV':
    //     transportIcon = Icons.airport_shuttle_rounded;
    //   case 'Electric Sedan':
    //     transportIcon = Icons.electric_car_rounded;
    //   case 'Bus':
    //     transportIcon = Icons.directions_bus_rounded;
    //   case 'Subway':
    //     transportIcon = Icons.directions_subway_rounded;
    //   case 'Train':
    //     transportIcon = Icons.directions_railway_rounded;
    //   default:
    //     transportIcon = Icons.directions_car_rounded;
    // }

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: cardShape,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
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
                          '$_assumpValue Km',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'per travel in a',
                          style: TextStyle(fontStyle: FontStyle.italic),
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

  factory TransportAssumption.fromMap(Map<String, dynamic> data) {
    return switch (data) {
      {
        'transport': String transport,
        'distance': int distance,
        'count': int count,
        'frequency': String frequency,
        'ghg_weekly': dynamic ghg,
        // --- Not Handled fields
        // 'inserted_at': _,
        // 'updated_at': _,
        // 'usr': _,
        // 'id': _,
      } =>
        TransportAssumption(
          assumCount: count,
          assumpLabel: transport,
          assumpValue: distance as T,
          frequency: Frequency.from(frequency),
          ghgEmission: double.parse(ghg.toString()),
        ),
      _ => throw const FormatException(
        'Failed to parse TransportAssumption from data (DB).',
      ),
    };
  }
}
