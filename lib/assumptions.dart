import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum Frequency {
  daily,
  weekly,
  monthly,
  yearly;

  // --- TODO: Find a better way to handle invalid strings
  static Frequency from(String val) {
    try {
      return Frequency.values.byName(val.trim().toLowerCase());
    } catch (e) {
      // --- This is not optimal
      return Frequency.weekly;
    }
  }
}

extension FrequencyExtensions on Frequency {
  int get count {
    switch (this) {
      case Frequency.daily:
        return 1;
      case Frequency.weekly:
        return Frequency.daily.count * 7;
      case Frequency.monthly:
        return Frequency.weekly.count * 4;
      case Frequency.yearly:
        return Frequency.monthly.count * 12;
    }
  }

  String get name {
    switch (this) {
      case Frequency.daily:
        return 'daily';
      case Frequency.weekly:
        return 'weekly';
      case Frequency.monthly:
        return 'monthly';
      case Frequency.yearly:
        return 'yearly';
    }
  }
}

abstract class Assumption<T> {
  String label();
  T value();
  Frequency frequency();
  int count();
  Widget toWidget();
  Map<String, Object?> toMap();
  double ghgValue();
}

class HousingAssumption<T> implements Assumption<T> {
  final String _assumpLabel;
  final T _assumpValue;
  final Frequency _assumFrequency;
  final int _assumpCount;

  const HousingAssumption({
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
                Icon(Icons.front_hand),
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
    // TODO: implement toMap
    throw UnimplementedError();
  }

  factory HousingAssumption.fromMap(Map<String, dynamic> data) {
    // TODO: implement fromMap
    throw UnimplementedError();
  }

  @override
  double ghgValue() {
    // TODO: implement ghgValue
    throw UnimplementedError();
  }
}

class TransportAssumption<T> implements Assumption<T> {
  final String _assumpLabel;
  final T _assumpValue;
  final Frequency _assumFrequency;
  final int _assumpCount;

  const TransportAssumption({
    required int assumCount,
    required String assumpLabel,
    required T assumpValue,
    required Frequency frequency,
  }) : _assumpValue = assumpValue,
       _assumpLabel = assumpLabel,
       _assumFrequency = frequency,
       _assumpCount = assumCount;

  @override
  Map<String, Object?> toMap() {
    return {
      'transport': _assumpValue,
      'distance': _assumpValue,
      'count': _assumpCount,
      'frequency': _assumFrequency,
      'inserted_at': DateTime.now().toUtc(),
    };
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

    final IconData transportIcon;
    switch (_assumpLabel) {
      case 'Sedan':
        transportIcon = Icons.directions_car_rounded;
      case 'SUV':
        transportIcon = Icons.airport_shuttle_rounded;
      case 'Electric Sedan':
        transportIcon = Icons.electric_car_rounded;
      case 'Bus':
        transportIcon = Icons.directions_bus_rounded;
      case 'Subway':
        transportIcon = Icons.directions_subway_rounded;
      case 'Train':
        transportIcon = Icons.directions_railway_rounded;
      default:
        transportIcon = Icons.directions_car_rounded;
    }

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
                Icon(transportIcon, size: 30, color: Colors.lightGreen),
                // Emissions and Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('$_assumpCount times ${_assumFrequency.name}.'),
                    Row(
                      spacing: 6,
                      children: [
                        Text(
                          '$_assumpValue Km',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'per travel',
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
                    return Row(
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
                        Text(' of GHG'),
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
        // --- Not Handled fields
        'inserted_at': _,
        'updated_at': _,
        'usr': _,
        'id': _,
      } =>
        TransportAssumption(
          assumCount: count,
          assumpLabel: transport,
          assumpValue: distance as T,
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

class AssumptionsModel extends ChangeNotifier {
  final List<Assumption> _assumptions = [];

  bool _isLoading = false;
  bool _hasInitialized = false;

  AssumptionsModel() {
    _innitProvider();
  }

  bool get loading => _isLoading;
  bool get initialized => _hasInitialized;

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Assumption> get items =>
      UnmodifiableListView(_assumptions);

  /// All the assumptions of a specific type T
  UnmodifiableListView<T> getAssumptionsPerType<T extends Assumption>() =>
      UnmodifiableListView(_assumptions.whereType<T>());

  /// Add [assumption] to assumptions.
  void add(Assumption assumption) {
    _assumptions.add(assumption);
    // Notifies listeners of list changes
    notifyListeners();
  }

  /// Removes all the [assumption]s from the list.
  void removeAll() {
    _assumptions.clear();
    // Notifies listeners of list changes
    notifyListeners();
  }

  // --- Logic
  //
  Future<void> _innitProvider() async {
    if (_hasInitialized) return;

    _isLoading = true;
    notifyListeners();

    await _fetchExistingTransportAssumps();

    _hasInitialized = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchExistingTransportAssumps() async {
    final supabase = Supabase.instance.client;

    final user = supabase.auth.currentUser;
    if (user == null) {
      throw const AuthException('The current user is unauthenticated');
    }

    var assumptions = await supabase.from('transport_assumption').select();

    var transportAssumps = assumptions
        .map((assum) => TransportAssumption<int>.fromMap(assum))
        .toList();

    _assumptions.addAll(transportAssumps);
  }
}
