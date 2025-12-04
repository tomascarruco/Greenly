import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenly/pages/assumptions.dart';
import 'package:vector_graphics/vector_graphics.dart';

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

    const Widget svgI = SvgPicture(
      AssetBytesLoader('assets/icons/svg/beef.svg.vec'),
      colorFilter: ColorFilter.mode(Colors.lightGreen, BlendMode.srcIn),
    );

    const Widget svgII = SvgPicture(
      AssetBytesLoader('assets/icons/svg/poultry.svg.vec'),
      colorFilter: ColorFilter.mode(Colors.lightGreen, BlendMode.srcIn),
    );

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: cardShape,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 18,
              children: [
                SizedBox(width: 30, height: 30, child: svgI),
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
                          '$_assumpValue ${_assumpCount > 1 ? "portions" : "portion"}',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'of $_assumpLabel',
                          style: TextStyle(fontStyle: FontStyle.italic),
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
                        // Icon(
                        //   Icons.keyboard_arrow_down,
                        //   color: Colors.red.shade500,
                        // ),
                        Text(
                          '200 Kg',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'GHG',
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
