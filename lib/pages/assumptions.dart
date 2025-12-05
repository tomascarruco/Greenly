import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:greenly/pages/collection/models/commute_assumption_model.dart';
import 'package:greenly/pages/collection/models/food_assumption_model.dart';
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
  void add(Assumption assumption) async {
    switch (assumption) {
      case TransportAssumption _:
        assumption = await _addTransportAssumptoDB(assumption) as Assumption;
      case FoodAssumption _:
        assumption = await _addFoodAssumptoBD(assumption) as Assumption;
    }
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

  Future<void> _innitProvider() async {
    if (_hasInitialized) return;

    _isLoading = true;
    notifyListeners();

    await _fetchExistingTransportAssumps();
    notifyListeners();

    await _fetchExistingFoodAssumps();
    notifyListeners();

    _hasInitialized = true;
    notifyListeners();
    _isLoading = false;
  }

  Future<TransportAssumption<T>> _addTransportAssumptoDB<T>(
    TransportAssumption<T> assump,
  ) async {
    final supabase = Supabase.instance.client;

    final user = supabase.auth.currentUser;
    if (user == null) {
      throw const AuthException('The current user is unauthenticated');
    }

    print('Is expired: ${supabase.auth.currentSession?.isExpired}');

    PostgrestList insertResults = await supabase
        .from('transport_assumption')
        .insert(assump.toMap())
        .select('ghg_weekly');

    int ghgEmission = insertResults.first['ghg_weekly'];

    Map<String, Object?> assumption = assump.toMap();
    assumption.update(
      'ghg_weekly',
      (m) => ghgEmission,
      ifAbsent: () => ghgEmission,
    );

    return Future.value(TransportAssumption.fromMap(assumption));
  }

  Future<FoodAssumption<T>> _addFoodAssumptoBD<T>(
    FoodAssumption<T> assump,
  ) async {
    final supabase = Supabase.instance.client;

    final user = supabase.auth.currentUser;
    if (user == null) {
      throw const AuthException('The current user is unauthenticated');
    }

    PostgrestList insertResults = await supabase
        .from('food_assumption')
        .insert(assump.toMap())
        .select('ghg_weekly');

    double ghgEmission = insertResults.first['ghg_weekly'];

    Map<String, Object?> assumption = assump.toMap();
    assumption.update(
      'ghg_weekly',
      (m) => ghgEmission,
      ifAbsent: () => ghgEmission,
    );

    return Future.value(FoodAssumption.fromMap(assumption));
  }

  Future<void> _fetchExistingTransportAssumps() async {
    final supabase = Supabase.instance.client;

    final user = supabase.auth.currentUser;
    if (user == null) {
      throw const AuthException('The current user is unauthenticated');
    }

    var assumptions = await supabase.from('transport_assumption').select();

    var transportAssumps = assumptions
        .map((assum) => TransportAssumption.fromMap(assum))
        .toList();

    _assumptions.addAll(transportAssumps);
  }

  Future<void> _fetchExistingFoodAssumps() async {
    final supabase = Supabase.instance.client;

    final user = supabase.auth.currentUser;
    if (user == null) {
      throw const AuthException('The current user is unauthenticated');
    }

    var assumptions = await supabase.from('food_assumption').select();

    var transportAssumps = assumptions
        .map((assum) => FoodAssumption.fromMap(assum))
        .toList();

    _assumptions.addAll(transportAssumps);
  }
}
