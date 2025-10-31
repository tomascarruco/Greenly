import 'package:flutter/material.dart';
import 'package:greenly/pages/assumptions.dart';

class FoodAssumption<T> implements Assumption<T> {
  final String _assumpLabel;
  final T _assumpValue;
  final Frequency _assumFrequency;
  final int _assumpCount;

  const FoodAssumption({
    required int assumCount,
    required String assumpLabel,
    required T assumpValue,
    required Frequency frequency,
  }) : _assumpValue = assumpValue,
       _assumpLabel = assumpLabel,
       _assumFrequency = frequency,
       _assumpCount = assumCount;

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
        width: 2,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    );

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: cardShape,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 12,
              children: [
                Icon(Icons.flatware_rounded),
                // Emissions and Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [],
                ),
              ],
            ),
            // Emissions delta indicator
            Row(
              children: [
                Builder(
                  builder: (context) {
                    return Row(
                      children: [
                        Icon(Icons.remove, color: Colors.grey.shade500),
                        Text('N/A'),
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
  Map<String, Object?> toMap() {
    return {
      'categorie': _assumpLabel,
      'count': _assumpCount,
      'frequency': _assumFrequency.name,
      'proportion_size': _assumpValue,
      // 'inserted_at': DateTime.now().toUtc(),
    };
  }

  factory FoodAssumption.fromMap(Map<String, dynamic> data) {
    return switch (data) {
      {
        'categorie': String categorie,
        'count': int count,
        'frequency': String frequency,
        'proportion_size': T proportionSize,
        // --- Not Handled fields
        'inserted_at': _,
        'updated_at': _,
        'usr': _,
        'id': _,
      } =>
        FoodAssumption(
          assumCount: count,
          assumpLabel: categorie,
          assumpValue: proportionSize,
          frequency: Frequency.from(frequency),
        ),
      _ => throw const FormatException(
        'Failed to parse TransportAssumption from data (DB).',
      ),
    };
  }

  @override
  double ghgValue() {
    // TODO: implement ghgValue
    throw UnimplementedError();
  }
}
