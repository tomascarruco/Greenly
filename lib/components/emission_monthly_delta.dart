import 'package:flutter/material.dart';

/// EmissionMonthlyDelta - Provides information regarding this months GHG emissions
/// as a [delta] bettwen the previous and current [date]s [value].
/// The delta must be provided
class EmissionMonthlyDelta extends StatelessWidget {
  final String date;
  final double value;
  final double delta;

  const EmissionMonthlyDelta(this.date, this.value, this.delta, {super.key});

  @override
  Widget build(BuildContext context) {
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
                Icon(Icons.front_hand),
                // Emissions and Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(date),
                    Row(
                      spacing: 6,
                      children: [
                        Text(
                          value.toStringAsFixed(2),
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'per month',
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
                    var deltaString = delta.toStringAsFixed(2);

                    if (delta < 0) {
                      return Row(
                        children: [
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.red.shade500,
                          ),
                          Text(deltaString),
                        ],
                      );
                    }
                    if (delta > 0) {
                      return Row(
                        children: [
                          Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.green.shade500,
                          ),
                          Text(deltaString),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Icon(Icons.remove, color: Colors.grey.shade500),
                        Text('N/A'),
                      ],
                    );
                  },
                ),
                Text(' T'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
